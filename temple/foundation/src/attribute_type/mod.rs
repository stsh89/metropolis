//! This module is dedicated to the [`AttributeType`] entity and the operations
//! on it.

mod create;
mod delete;
mod get;
mod list;
mod update;

mod tests;

use crate::{datastore::Record, util, FoundationResult};

pub use create::{execute as create, Request as CreateRequest};
pub use delete::execute as delete;
pub use get::execute as get;
pub use list::execute as list;
pub use update::execute as update;

#[async_trait::async_trait]
pub trait CreateAttributeTypeRecord {
    async fn create_attribute_type_record(
        &self,
        attribute_type: AttributeType,
    ) -> FoundationResult<AttributeTypeRecord>;
}

#[async_trait::async_trait]
pub trait UpdateAttributeTypeRecord {
    async fn update_attribute_type_record(
        &self,
        attribute_type: AttributeTypeRecord,
    ) -> FoundationResult<AttributeTypeRecord>;
}

#[async_trait::async_trait]
pub trait ListAttributeTypeRecords {
    async fn list_attribute_type_records(&self) -> FoundationResult<Vec<AttributeTypeRecord>>;
}

#[async_trait::async_trait]
pub trait GetAttributeTypeRecord {
    async fn get_attribute_type_record(
        &self,
        slug: &str,
    ) -> FoundationResult<Option<AttributeTypeRecord>>;
}

#[async_trait::async_trait]
pub trait DeleteAttributeTypeRecord {
    async fn delete_attribute_type_record(
        &self,
        attribute_type_record: AttributeTypeRecord,
    ) -> FoundationResult<()>;
}

#[derive(Clone, Debug, PartialEq)]
/// Represents an attribute type of the model.
pub struct AttributeType {
    /// An optional hint about how the type is used or what it's intended for.
    pub description: Option<String>,

    /// Name that is unique within the list of all [`AttributeType`]s.
    pub name: String,

    /// Web identifier that is unique within the list of all [`AttributeType`]s.
    pub slug: String,
}

/// Repository [`AttributeType`] representation.
pub type AttributeTypeRecord = Record<AttributeType>;

impl From<AttributeTypeRecord> for AttributeType {
    fn from(value: AttributeTypeRecord) -> Self {
        value.into_inner()
    }
}

fn validate_slug(slug: &str) -> FoundationResult<()> {
    let validation_errors = util::validator::Validator::new()
        .validate_required("slug", slug)
        .validate();

    if validation_errors.is_empty() {
        return Ok(());
    }

    Err(validation_errors.first().cloned().unwrap().into())
}
