//! This module is dedicated to the [`AttributeType`] entity and the operations
//! on it.

mod create;
mod get;
mod list;

mod tests;

use crate::{datastore::Record, FoundationResult};

pub use create::execute as create;
pub use get::execute as get;
pub use list::execute as list;

#[async_trait::async_trait]
pub trait CreateAttributeTypeRecord {
    async fn create_attribute_type_record(
        &self,
        attribute_type: AttributeType,
    ) -> FoundationResult<AttributeTypeRecord>;
}

#[async_trait::async_trait]
pub trait ListAttributeTypeRecords {
    async fn list_attribute_type_records(&self) -> FoundationResult<Vec<AttributeTypeRecord>>;
}

#[async_trait::async_trait]
pub trait GetAttributeTypeRecord {
    async fn get_attribute_type_record(&self, slug: &str) -> FoundationResult<AttributeTypeRecord>;
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
