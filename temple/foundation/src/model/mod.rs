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

use crate::{datastore, util, FoundationError};

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
            datastore::model::AttributeKind::Int64 => AttributeKind::Integer,
            datastore::model::AttributeKind::Bool => AttributeKind::Boolean,
        }
    }
}

impl From<AttributeKind> for datastore::model::AttributeKind {
    fn from(value: AttributeKind) -> Self {
        match value {
            AttributeKind::String => datastore::model::AttributeKind::String,
            AttributeKind::Integer => datastore::model::AttributeKind::Int64,
            AttributeKind::Boolean => datastore::model::AttributeKind::Bool,
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
            "int64" => Ok(AttributeKind::Integer),
            "bool" => Ok(AttributeKind::Boolean),
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
    use crate::tests::{
        model_attribute_record_fixture, model_record_fixture, ModelAssociationRepo,
        ModelAttributeRepo, ModelRepo, ProjectRepo,
    };

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
