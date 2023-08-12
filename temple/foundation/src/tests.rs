#![cfg(test)]

use super::*;
use crate::{datastore::model::AttributeKind, FoundationError, FoundationResult, Uuid};
use std::collections::HashMap;
use tokio::sync::RwLock;

pub struct ProjectRepo {
    pub records: RwLock<HashMap<Uuid, datastore::project::Project>>,
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

    // pub async fn get(&self, id: Uuid) -> FoundationResult<datastore::model::Model> {
    //     let records = self.records.read().await;

    //     records
    //         .get(&id)
    //         .cloned()
    //         .ok_or(FoundationError::not_found(format!(
    //             "no Model with id: `{id}`",
    //         )))
    // }

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

    pub async fn records(&self) -> Vec<datastore::model::Attribute> {
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
pub struct AttributeRecordFixture {
    pub model_id: Option<Uuid>,
    pub description: Option<String>,
    pub kind: Option<AttributeKind>,
    pub name: Option<String>,
}

pub fn attribute_record_fixture(fixture: AttributeRecordFixture) -> datastore::model::Attribute {
    let AttributeRecordFixture {
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
