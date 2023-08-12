pub mod create;
pub mod create_attribute;

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
    pub description: String,

    pub kind: AssociationKind,

    pub model: Model,
}

#[derive(Clone, Debug, PartialEq)]
pub enum AttributeKind {
    String,

    Int64,

    Bool,
}

#[derive(Clone, Debug, PartialEq)]
pub enum AssociationKind {
    BelongsTo,

    HasOne,

    ManyToMany,
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
            datastore::model::AttributeKind::Int64 => AttributeKind::Int64,
            datastore::model::AttributeKind::Bool => AttributeKind::Bool,
        }
    }
}

impl From<AttributeKind> for datastore::model::AttributeKind {
    fn from(value: AttributeKind) -> Self {
        match value {
            AttributeKind::String => datastore::model::AttributeKind::String,
            AttributeKind::Int64 => datastore::model::AttributeKind::Int64,
            AttributeKind::Bool => datastore::model::AttributeKind::Bool,
        }
    }
}

impl PartialEq for Model {
    fn eq(&self, other: &Self) -> bool {
        self.description == other.description && self.name == other.name && self.slug == other.slug
    }
}

impl PartialEq for Attribute {
    fn eq(&self, other: &Self) -> bool {
        self.description == other.description && self.name == other.name && self.kind == other.kind
    }
}

impl PartialEq for Association {
    fn eq(&self, other: &Self) -> bool {
        self.description == other.description
            && self.kind == other.kind
            && self.model == other.model
    }
}

impl FromStr for AttributeKind {
    type Err = FoundationError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "string" => Ok(AttributeKind::String),
            "int64" => Ok(AttributeKind::Int64),
            "Bool" => Ok(AttributeKind::Bool),
            other => Err(FoundationError::invalid_argument(format! {
                "`#{other}` is not a valid AttributeKind for the Model"
            })),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::tests::{
        attribute_record_fixture, model_record_fixture, ModelAttributeRepo, ModelRepo, ProjectRepo,
    };

    pub struct Repo {
        pub project_repo: ProjectRepo,
        pub model_repo: ModelRepo,
        pub model_attribute_repo: ModelAttributeRepo,
    }

    impl Default for Repo {
        fn default() -> Self {
            Self {
                project_repo: ProjectRepo::seed(vec![]),
                model_repo: ModelRepo::seed(vec![]),
                model_attribute_repo: ModelAttributeRepo::seed(vec![]),
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
        let attribute_record = attribute_record_fixture(Default::default());

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
