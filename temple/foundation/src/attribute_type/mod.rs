//! This module is dedicated to the [`AttributeType`] entity and the operations
//! on it.

use crate::datastore::Record;

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
