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

mod tests;

use std::str::FromStr;

use crate::{
    attribute_type::{AttributeType, AttributeTypeRecord},
    datastore, util, FoundationError, FoundationResult,
};

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
        attribute_type_record: AttributeTypeRecord,
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

    pub r#type: AttributeType,

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

impl From<datastore::model::ModelOverview> for ModelOverview {
    fn from(value: datastore::model::ModelOverview) -> Self {
        let datastore::model::ModelOverview {
            model,
            associations,
            attributes,
        } = value;

        Self {
            model: model.into(),
            associations: associations.into_iter().map(Into::into).collect(),
            attributes: attributes.into_iter().map(Into::into).collect(),
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
            r#type,
            inserted_at: _,
            updated_at: _,
        } = value;

        Self {
            description: util::string::optional(&description),
            name,
            r#type: r#type.into(),
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
            r#type,
            name,
        } = other;

        &self.description == description && &self.name == name && &self.r#type == r#type
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
