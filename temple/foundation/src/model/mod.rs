pub mod create;
pub mod create_association;
pub mod create_attribute;
pub mod delete;
pub mod delete_association;
pub mod delete_attribute;
pub mod get;
pub mod get_class_diagram;
pub mod get_project_class_diagram;
pub mod list;

use std::str::FromStr;

use crate::{datastore, util, FoundationError, FoundationResult};

#[async_trait::async_trait]
pub trait CreateModelRecord {
    async fn create_model_record(
        &self,
        project: datastore::project::Project,
        model: Model,
    ) -> FoundationResult<datastore::model::Model>;
}

#[async_trait::async_trait]
pub trait GetModelOverviewRecord {
    async fn get_model_overview_record(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::ModelOverview>;
}

#[async_trait::async_trait]
pub trait ListModelRecords {
    async fn list_model_records(
        &self,
        project_slug: &str,
    ) -> FoundationResult<Vec<datastore::model::Model>>;
}

#[async_trait::async_trait]
pub trait GetModelRecord {
    async fn get_model_record(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::Model>;
}

#[async_trait::async_trait]
pub trait DeleteModelRecord {
    async fn delete_model_record(
        &self,
        model_record: datastore::model::Model,
    ) -> FoundationResult<()>;
}

#[async_trait::async_trait]
pub trait ListModelOverviewRecords {
    async fn list_model_overview_records(
        &self,
        project_slug: &str,
    ) -> FoundationResult<Vec<datastore::model::ModelOverview>>;
}

#[async_trait::async_trait]
pub trait GetModelAttributeRecord {
    async fn get_model_attribute_record(
        &self,
        project_slug: &str,
        model_slug: &str,
        name: &str,
    ) -> FoundationResult<datastore::model::Attribute>;
}

#[async_trait::async_trait]
pub trait DeleteModelAttributeRecord {
    async fn delete_model_attribute_record(
        &self,
        attribute: datastore::model::Attribute,
    ) -> FoundationResult<()>;
}

#[async_trait::async_trait]
pub trait GetModelAssociationRecord {
    async fn get_model_association_record(
        &self,
        project_slug: &str,
        model_slug: &str,
        name: &str,
    ) -> FoundationResult<datastore::model::Association>;
}

#[async_trait::async_trait]
pub trait DeleteModelAssociationRecord {
    async fn delete_model_association_record(
        &self,
        association: datastore::model::Association,
    ) -> FoundationResult<()>;
}

#[async_trait::async_trait]
pub trait CreateModelAttributeRecord {
    async fn create_model_attribute_record(
        &self,
        model: datastore::model::Model,
        attribute: Attribute,
    ) -> FoundationResult<datastore::model::Attribute>;
}

#[async_trait::async_trait]
pub trait CreateModelAssociationRecord {
    async fn create_model_association_record(
        &self,
        model: datastore::model::Model,
        associated_model: datastore::model::Model,
        association: Association,
    ) -> FoundationResult<datastore::model::Association>;
}

#[derive(Clone, Debug)]
pub struct Model {
    pub description: Option<String>,

    pub name: String,

    pub slug: String,
}

#[derive(Clone, Debug)]
pub struct Attribute {
    pub description: Option<String>,

    pub kind: AttributeKind,

    pub name: String,
}

#[derive(Clone, Debug)]
pub struct Association {
    pub description: Option<String>,

    pub kind: AssociationKind,

    pub model: Model,

    pub name: String,
}

#[derive(Clone, Debug, PartialEq)]
pub enum AttributeKind {
    String,

    Integer,

    Boolean,
}

#[derive(Clone, Debug, PartialEq)]
pub enum AssociationKind {
    BelongsTo,

    HasOne,

    HasMany,
}

#[derive(Clone, Debug)]
pub struct ModelOverview {
    pub model: Model,

    pub attributes: Vec<Attribute>,

    pub associations: Vec<Association>,
}

impl From<datastore::model::Model> for Model {
    fn from(value: datastore::model::Model) -> Self {
        let datastore::model::Model {
            id: _,
            project_id: _,
            description,
            name,
            slug,
            inserted_at: _,
            updated_at: _,
        } = value;

        Self {
            description: util::string::optional(&description),
            name,
            slug,
        }
    }
}

impl From<datastore::model::Attribute> for Attribute {
    fn from(value: datastore::model::Attribute) -> Self {
        let datastore::model::Attribute {
            id: _,
            model_id: _,
            description,
            name,
            kind,
            inserted_at: _,
            updated_at: _,
        } = value;

        Self {
            description: util::string::optional(&description),
            name,
            kind: kind.into(),
        }
    }
}

impl From<datastore::model::AttributeKind> for AttributeKind {
    fn from(value: datastore::model::AttributeKind) -> Self {
        match value {
            datastore::model::AttributeKind::String => AttributeKind::String,
            datastore::model::AttributeKind::Integer => AttributeKind::Integer,
            datastore::model::AttributeKind::Boolean => AttributeKind::Boolean,
        }
    }
}

impl From<AttributeKind> for datastore::model::AttributeKind {
    fn from(value: AttributeKind) -> Self {
        match value {
            AttributeKind::String => datastore::model::AttributeKind::String,
            AttributeKind::Integer => datastore::model::AttributeKind::Integer,
            AttributeKind::Boolean => datastore::model::AttributeKind::Boolean,
        }
    }
}

impl From<datastore::model::Association> for Association {
    fn from(value: datastore::model::Association) -> Self {
        let datastore::model::Association {
            id: _,
            model_id: _,
            associated_model,
            description,
            kind,
            name,
            inserted_at: _,
            updated_at: _,
        } = value;

        Self {
            description: util::string::optional(&description),
            kind: kind.into(),
            model: associated_model.into(),
            name,
        }
    }
}

impl From<datastore::model::AssociationKind> for AssociationKind {
    fn from(value: datastore::model::AssociationKind) -> Self {
        use datastore::model::AssociationKind::*;

        match value {
            BelongsTo => AssociationKind::BelongsTo,
            HasOne => AssociationKind::HasOne,
            HasMany => AssociationKind::HasMany,
        }
    }
}

impl From<AssociationKind> for datastore::model::AssociationKind {
    fn from(value: AssociationKind) -> Self {
        use datastore::model::AssociationKind::*;

        match value {
            AssociationKind::BelongsTo => BelongsTo,
            AssociationKind::HasOne => HasOne,
            AssociationKind::HasMany => HasMany,
        }
    }
}

impl PartialEq for Model {
    fn eq(&self, other: &Self) -> bool {
        let Model {
            description,
            name,
            slug,
        } = other;

        &self.description == description && &self.name == name && &self.slug == slug
    }
}

impl PartialEq for Attribute {
    fn eq(&self, other: &Self) -> bool {
        let Attribute {
            description,
            kind,
            name,
        } = other;

        &self.description == description && &self.name == name && &self.kind == kind
    }
}

impl PartialEq for Association {
    fn eq(&self, other: &Self) -> bool {
        let Association {
            description,
            kind,
            model,
            name,
        } = other;

        &self.description == description
            && &self.kind == kind
            && &self.model == model
            && &self.name == name
    }
}

impl FromStr for AttributeKind {
    type Err = FoundationError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "string" => Ok(AttributeKind::String),
            "integer" => Ok(AttributeKind::Integer),
            "boolean" => Ok(AttributeKind::Boolean),
            other => Err(FoundationError::invalid_argument(format! {
                "`#{other}` is not a valid AttributeKind for the Model"
            })),
        }
    }
}

impl FromStr for AssociationKind {
    type Err = FoundationError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "belongs_to" => Ok(AssociationKind::BelongsTo),
            "has_one" => Ok(AssociationKind::HasOne),
            "has_many" => Ok(AssociationKind::HasMany),
            other => Err(FoundationError::invalid_argument(format! {
                "`#{other}` is not a valid AssociationKind for the Model"
            })),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        project::GetProjectRecord,
        tests::{
            model_attribute_record_fixture, model_record_fixture, ModelAssociationRepo,
            ModelAttributeRepo, ModelRepo, ProjectRepo,
        },
    };

    #[async_trait::async_trait]
    impl CreateModelRecord for Repo {
        async fn create_model_record(
            &self,
            project_record: datastore::project::Project,
            model: Model,
        ) -> FoundationResult<datastore::model::Model> {
            let Model {
                description,
                name,
                slug,
            } = model;

            let mut model_records = self.model_repo.records.write().await;

            let model_record = datastore::model::Model {
                project_id: project_record.id,
                description: description.unwrap_or_default(),
                name,
                slug,
                ..Default::default()
            };

            model_records.insert(model_record.id, model_record.clone());

            Ok(model_record)
        }
    }

    #[async_trait::async_trait]
    impl GetProjectRecord for Repo {
        async fn get_project_record(
            &self,
            slug: &str,
        ) -> FoundationResult<datastore::project::Project> {
            self.project_repo.get_project_record(slug).await
        }
    }

    #[async_trait::async_trait]
    impl GetModelOverviewRecord for Repo {
        async fn get_model_overview_record(
            &self,
            project_slug: &str,
            model_slug: &str,
        ) -> FoundationResult<datastore::model::ModelOverview> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            let model_record = self
                .model_repo
                .find_by_slug(project_record.id, model_slug)
                .await?;
            let model_attribute_records = self.model_attribute_repo.list(model_record.id).await?;
            let model_association_records =
                self.model_association_repo.list(model_record.id).await?;

            Ok(datastore::model::ModelOverview {
                model: model_record,
                attributes: model_attribute_records,
                associations: model_association_records,
            })
        }
    }

    #[async_trait::async_trait]
    impl ListModelRecords for Repo {
        async fn list_model_records(
            &self,
            project_slug: &str,
        ) -> FoundationResult<Vec<datastore::model::Model>> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            let model_records = self
                .model_repo
                .records()
                .await
                .into_iter()
                .filter(|model_record| model_record.project_id == project_record.id)
                .collect();

            Ok(model_records)
        }
    }

    #[async_trait::async_trait]
    impl GetModelRecord for Repo {
        async fn get_model_record(
            &self,
            project_slug: &str,
            model_slug: &str,
        ) -> FoundationResult<datastore::model::Model> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            self.model_repo
                .find_by_slug(project_record.id, model_slug)
                .await
        }
    }

    #[async_trait::async_trait]
    impl DeleteModelRecord for Repo {
        async fn delete_model_record(
            &self,
            model_record: datastore::model::Model,
        ) -> FoundationResult<()> {
            let mut model_records = self.model_repo.records.write().await;

            model_records.remove(&model_record.id);

            Ok(())
        }
    }

    #[async_trait::async_trait]
    impl ListModelOverviewRecords for Repo {
        async fn list_model_overview_records(
            &self,
            project_slug: &str,
        ) -> FoundationResult<Vec<datastore::model::ModelOverview>> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            let mut model_records: Vec<datastore::model::Model> = self
                .model_repo
                .records()
                .await
                .into_iter()
                .filter(|model_record| model_record.project_id == project_record.id)
                .collect();

            model_records.sort_by(|a, b| a.name.cmp(&b.name));

            let mut model_overviews: Vec<datastore::model::ModelOverview> =
                Vec::with_capacity(model_records.len());

            for model_record in model_records {
                let associations = self.model_association_repo.list(model_record.id).await?;
                let attributes = self.model_attribute_repo.list(model_record.id).await?;

                model_overviews.push(datastore::model::ModelOverview {
                    model: model_record,
                    associations,
                    attributes,
                });
            }

            Ok(model_overviews)
        }
    }

    #[async_trait::async_trait]
    impl GetModelAttributeRecord for Repo {
        async fn get_model_attribute_record(
            &self,
            project_slug: &str,
            model_slug: &str,
            model_attribute_name: &str,
        ) -> FoundationResult<datastore::model::Attribute> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            let model_record = self
                .model_repo
                .find_by_slug(project_record.id, model_slug)
                .await?;

            self.model_attribute_repo
                .find_by_name(model_record.id, model_attribute_name)
                .await
        }
    }

    #[async_trait::async_trait]
    impl DeleteModelAttributeRecord for Repo {
        async fn delete_model_attribute_record(
            &self,
            model_attribute_record: datastore::model::Attribute,
        ) -> FoundationResult<()> {
            let mut model_attribute_records = self.model_attribute_repo.records.write().await;

            model_attribute_records.remove(&model_attribute_record.id);

            Ok(())
        }
    }

    #[async_trait::async_trait]
    impl GetModelAssociationRecord for Repo {
        async fn get_model_association_record(
            &self,
            project_slug: &str,
            model_slug: &str,
            model_association_name: &str,
        ) -> FoundationResult<datastore::model::Association> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            let model_record = self
                .model_repo
                .find_by_slug(project_record.id, model_slug)
                .await?;

            self.model_association_repo
                .find_by_name(model_record.id, model_association_name)
                .await
        }
    }

    #[async_trait::async_trait]
    impl DeleteModelAssociationRecord for Repo {
        async fn delete_model_association_record(
            &self,
            model_association_record: datastore::model::Association,
        ) -> FoundationResult<()> {
            let mut model_association_records = self.model_association_repo.records.write().await;

            model_association_records.remove(&model_association_record.id);

            Ok(())
        }
    }

    #[async_trait::async_trait]
    impl CreateModelAttributeRecord for Repo {
        async fn create_model_attribute_record(
            &self,
            model_record: datastore::model::Model,
            attribute: Attribute,
        ) -> FoundationResult<datastore::model::Attribute> {
            let Attribute {
                description,
                name,
                kind,
            } = attribute;

            let mut model_attribute_records = self.model_attribute_repo.records.write().await;

            let model_attribute_record = datastore::model::Attribute {
                model_id: model_record.id,
                description: description.unwrap_or_default(),
                name,
                kind: kind.into(),
                ..Default::default()
            };

            model_attribute_records
                .insert(model_attribute_record.id, model_attribute_record.clone());

            Ok(model_attribute_record)
        }
    }

    #[async_trait::async_trait]
    impl CreateModelAssociationRecord for Repo {
        async fn create_model_association_record(
            &self,
            model_record: datastore::model::Model,
            associated_model_record: datastore::model::Model,
            association: Association,
        ) -> FoundationResult<datastore::model::Association> {
            let Association {
                description,
                name,
                kind,
                model: _,
            } = association;

            let mut model_association_records = self.model_association_repo.records.write().await;

            let model_association_record = datastore::model::Association {
                model_id: model_record.id,
                description: description.unwrap_or_default(),
                name,
                kind: kind.into(),
                associated_model: associated_model_record,
                ..Default::default()
            };

            model_association_records.insert(
                model_association_record.id,
                model_association_record.clone(),
            );

            Ok(model_association_record)
        }
    }

    pub struct Repo {
        pub project_repo: ProjectRepo,
        pub model_repo: ModelRepo,
        pub model_attribute_repo: ModelAttributeRepo,
        pub model_association_repo: ModelAssociationRepo,
    }

    impl Default for Repo {
        fn default() -> Self {
            Self {
                project_repo: ProjectRepo::seed(vec![]),
                model_repo: ModelRepo::seed(vec![]),
                model_attribute_repo: ModelAttributeRepo::seed(vec![]),
                model_association_repo: ModelAssociationRepo::seed(vec![]),
            }
        }
    }

    #[test]
    fn it_converts_model_from_record() {
        let model_record = model_record_fixture(Default::default());

        let model: Model = model_record.into();

        assert_eq!(
            model,
            Model {
                name: "Book".to_string(),
                slug: "book".to_string(),
                description: None,
            }
        )
    }

    #[test]
    fn it_converts_attribute_from_record() {
        let attribute_record = model_attribute_record_fixture(Default::default());

        let attribute: Attribute = attribute_record.into();

        assert_eq!(
            attribute,
            Attribute {
                name: "Title".to_string(),
                kind: AttributeKind::String,
                description: None,
            }
        )
    }
}
