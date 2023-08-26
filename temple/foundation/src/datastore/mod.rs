//! This module contains persistence layer details.

pub mod model;
pub mod project;

mod tests;

use crate::{UtcDateTime, Uuid};

/// Generic representation of the model in the repository.
pub struct Record<T> {
    /// Identifier that is unique within the list of all records.
    pub id: Uuid,

    /// The actual data that is stored in the repository.
    pub inner: T,

    /// The time the record was added to the repository.
    pub inserted_at: UtcDateTime,

    /// The last time that the record was changed.
    pub updated_at: UtcDateTime,
}

impl<T> Record<T> {
    /// Returns the actual data that is stored.
    pub fn into_inner(self) -> T {
        self.inner
    }
}
