#![cfg(test)]

use super::*;
use crate::{
    datastore::model::{AssociationKind, AttributeKind},
    project::{
        ArchiveProjectRecord, CreateProjectRecord, DeleteProjectRecord, GetProjectRecord,
        ListProjectRecordFilterArchive, ListProjectRecordFilters, ListProjectRecords, Project,
        RenameProjectRecord, RestoreProjectRecord,
    },
    FoundationError, FoundationResult, Uuid,
};
use std::collections::HashMap;
use tokio::sync::RwLock;

pub struct ProjectRepo {
    pub records: RwLock<HashMap<Uuid, datastore::project::Project>>,
}

#[async_trait::async_trait]
impl CreateProjectRecord for ProjectRepo {
    async fn create_project_record(
        &self,
        project: Project,
    ) -> FoundationResult<datastore::project::Project> {
        let Project {
            description,
            name,
            slug,
        } = project;

        let mut project_records = self.records.write().await;

        let project_record = datastore::project::Project {
            description: description.unwrap_or_default(),
            name,
            slug,
            ..Default::default()
        };

        project_records.insert(project_record.id, project_record.clone());

        Ok(project_record)
    }
}

#[async_trait::async_trait]
impl RenameProjectRecord for ProjectRepo {
    async fn rename_project_record(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<datastore::project::Project> {
        let mut found_project_record = self.get(project_record.id).await?;

        let mut project_records = self.records.write().await;

        found_project_record.name = project_record.name;
        found_project_record.slug = project_record.slug;

        project_records.insert(found_project_record.id, found_project_record.clone());

        Ok(found_project_record)
    }
}

#[async_trait::async_trait]
impl GetProjectRecord for ProjectRepo {
    async fn get_project_record(
        &self,
        slug: &str,
    ) -> FoundationResult<datastore::project::Project> {
        self.find_by_slug(&slug).await
    }
}

#[async_trait::async_trait]
impl ListProjectRecords for ProjectRepo {
    async fn list_project_records(
        &self,
        filters: ListProjectRecordFilters,
    ) -> FoundationResult<Vec<datastore::project::Project>> {
        let project_records = self
            .records
            .read()
            .await
            .values()
            .filter(|project| match filters.archive_filter {
                ListProjectRecordFilterArchive::Any => true,
                ListProjectRecordFilterArchive::ArchivedOnly => project.archived_at.is_some(),
                ListProjectRecordFilterArchive::NotArchivedOnly => project.archived_at.is_none(),
            })
            .cloned()
            .collect();

        Ok(project_records)
    }
}

#[async_trait::async_trait]
impl DeleteProjectRecord for ProjectRepo {
    async fn delete_project_record(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<()> {
        let mut project_records = self.records.write().await;

        project_records.remove(&project_record.id);

        Ok(())
    }
}

#[async_trait::async_trait]
impl RestoreProjectRecord for ProjectRepo {
    async fn restore_project_record(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<()> {
        let mut found_project_record = self.get(project_record.id).await?;

        let mut project_records = self.records.write().await;

        found_project_record.archived_at = None;

        project_records.insert(found_project_record.id, found_project_record.clone());

        Ok(())
    }
}

#[async_trait::async_trait]
impl ArchiveProjectRecord for ProjectRepo {
    async fn archive_project_record(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<()> {
        let mut found_project_record = self.get(project_record.id).await?;

        let mut project_records = self.records.write().await;

        found_project_record.archived_at = Some(Utc::now());

        project_records.insert(found_project_record.id, found_project_record.clone());

        Ok(())
    }
}

impl ProjectRepo {
    pub fn seed(records: Vec<datastore::project::Project>) -> Self {
        let iter: HashMap<Uuid, datastore::project::Project> = records
            .into_iter()
            .map(|record| (record.id, record))
            .collect();

        Self {
            records: RwLock::new(HashMap::from_iter(iter)),
        }
    }

    pub async fn find_by_slug(&self, slug: &str) -> FoundationResult<datastore::project::Project> {
        let records = self.records.read().await;

        records
            .values()
            .find(|record| record.slug == slug)
            .cloned()
            .ok_or(FoundationError::not_found(format!(
                "no Project with slug: `{slug}`"
            )))
    }

    pub async fn get(&self, id: Uuid) -> FoundationResult<datastore::project::Project> {
        let records = self.records.read().await;

        records
            .get(&id)
            .cloned()
            .ok_or(FoundationError::not_found(format!(
                "no Project with id: `{id}`",
            )))
    }

    pub async fn records(&self) -> Vec<datastore::project::Project> {
        self.records.read().await.values().cloned().collect()
    }
}

pub struct ModelRepo {
    pub records: RwLock<HashMap<Uuid, datastore::model::Model>>,
}

impl ModelRepo {
    pub fn seed(records: Vec<datastore::model::Model>) -> Self {
        let iter: HashMap<Uuid, datastore::model::Model> = records
            .into_iter()
            .map(|record| (record.id, record))
            .collect();

        Self {
            records: RwLock::new(HashMap::from_iter(iter)),
        }
    }

    pub async fn find_by_slug(
        &self,
        project_id: Uuid,
        slug: &str,
    ) -> FoundationResult<datastore::model::Model> {
        let records = self.records.read().await;

        records
            .values()
            .find(|record| record.project_id == project_id && record.slug == slug)
            .cloned()
            .ok_or(FoundationError::not_found(format!(
                "no Model with the slug: `{slug}`, and project_id: `#{project_id}`"
            )))
    }

    pub async fn records(&self) -> Vec<datastore::model::Model> {
        self.records.read().await.values().cloned().collect()
    }
}

pub struct ModelAttributeRepo {
    pub records: RwLock<HashMap<Uuid, datastore::model::Attribute>>,
}

impl ModelAttributeRepo {
    pub fn seed(records: Vec<datastore::model::Attribute>) -> Self {
        let iter: HashMap<Uuid, datastore::model::Attribute> = records
            .into_iter()
            .map(|record| (record.id, record))
            .collect();

        Self {
            records: RwLock::new(HashMap::from_iter(iter)),
        }
    }

    pub async fn find_by_name(
        &self,
        model_id: Uuid,
        name: &str,
    ) -> FoundationResult<datastore::model::Attribute> {
        let records = self.records.read().await;

        records
            .values()
            .find(|record| record.model_id == model_id && record.name == name)
            .cloned()
            .ok_or(FoundationError::not_found(format!(
                "no ModelAttribute with the name: `{name}`, and model_id: `#{model_id}`"
            )))
    }

    pub async fn list(&self, model_id: Uuid) -> FoundationResult<Vec<datastore::model::Attribute>> {
        let records = self.records.read().await;

        let list = records
            .values()
            .filter(|record| record.model_id == model_id)
            .cloned()
            .collect();

        Ok(list)
    }

    pub async fn records(&self) -> Vec<datastore::model::Attribute> {
        self.records.read().await.values().cloned().collect()
    }
}

pub struct ModelAssociationRepo {
    pub records: RwLock<HashMap<Uuid, datastore::model::Association>>,
}

impl ModelAssociationRepo {
    pub fn seed(records: Vec<datastore::model::Association>) -> Self {
        let iter: HashMap<Uuid, datastore::model::Association> = records
            .into_iter()
            .map(|record| (record.id, record))
            .collect();

        Self {
            records: RwLock::new(HashMap::from_iter(iter)),
        }
    }

    pub async fn find_by_name(
        &self,
        model_id: Uuid,
        name: &str,
    ) -> FoundationResult<datastore::model::Association> {
        let records = self.records.read().await;

        records
            .values()
            .find(|record| record.model_id == model_id && record.name == name)
            .cloned()
            .ok_or(FoundationError::not_found(format!(
                "no ModelAssociation with the name: `{name}`, and model_id: `#{model_id}`"
            )))
    }

    pub async fn list(
        &self,
        model_id: Uuid,
    ) -> FoundationResult<Vec<datastore::model::Association>> {
        let records = self.records.read().await;

        let list = records
            .values()
            .filter(|record| record.model_id == model_id)
            .cloned()
            .collect();

        Ok(list)
    }

    pub async fn records(&self) -> Vec<datastore::model::Association> {
        self.records.read().await.values().cloned().collect()
    }
}

#[derive(Default)]
pub struct ProjectRecordFixture {
    pub name: Option<String>,
    pub slug: Option<String>,
    pub description: Option<String>,
    pub archived_at: Option<UtcDateTime>,
}

pub fn project_record_fixture(fixture: ProjectRecordFixture) -> datastore::project::Project {
    let ProjectRecordFixture {
        name,
        slug,
        description,
        archived_at,
    } = fixture;

    datastore::project::Project {
        name: name.unwrap_or("Book store".to_string()),
        slug: slug.unwrap_or("book-store".to_string()),
        description: description.unwrap_or_default(),
        archived_at,
        ..Default::default()
    }
}

#[derive(Default)]
pub struct ModelRecordFixture {
    pub project_id: Option<Uuid>,
    pub name: Option<String>,
    pub slug: Option<String>,
    pub description: Option<String>,
}

pub fn model_record_fixture(fixture: ModelRecordFixture) -> datastore::model::Model {
    let ModelRecordFixture {
        project_id,
        name,
        slug,
        description,
    } = fixture;

    datastore::model::Model {
        project_id: project_id.unwrap_or(Uuid::new_v4()),
        name: name.unwrap_or("Book".to_string()),
        slug: slug.unwrap_or("book".to_string()),
        description: description.unwrap_or_default(),
        ..Default::default()
    }
}

#[derive(Default)]
pub struct ModelAttributeRecordFixture {
    pub model_id: Option<Uuid>,
    pub description: Option<String>,
    pub kind: Option<AttributeKind>,
    pub name: Option<String>,
}

pub fn model_attribute_record_fixture(
    fixture: ModelAttributeRecordFixture,
) -> datastore::model::Attribute {
    let ModelAttributeRecordFixture {
        model_id,
        description,
        kind,
        name,
    } = fixture;

    datastore::model::Attribute {
        model_id: model_id.unwrap_or(Uuid::new_v4()),
        description: description.unwrap_or_default(),
        kind: kind.unwrap_or_default(),
        name: name.unwrap_or("Title".to_string()),
        ..Default::default()
    }
}

#[derive(Default)]
pub struct ModelAssociationRecordFixture {
    pub model_id: Option<Uuid>,
    pub associated_model: Option<datastore::model::Model>,
    pub description: Option<String>,
    pub kind: Option<AssociationKind>,
    pub name: Option<String>,
}

pub fn model_association_record_fixture(
    fixture: ModelAssociationRecordFixture,
) -> datastore::model::Association {
    let ModelAssociationRecordFixture {
        model_id,
        associated_model,
        description,
        kind,
        name,
    } = fixture;

    datastore::model::Association {
        model_id: model_id.unwrap_or(Uuid::new_v4()),
        associated_model: associated_model.unwrap_or(model_record_fixture(Default::default())),
        description: description.unwrap_or_default(),
        kind: kind.unwrap_or_default(),
        name: name.unwrap_or("Publisher".to_string()),
        ..Default::default()
    }
}
