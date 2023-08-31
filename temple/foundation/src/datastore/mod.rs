//! This module contains persistence layer details.

pub mod model;
pub mod project;

pub mod tests;

use crate::{Utc, UtcDateTime, Uuid};

#[derive(Clone, Debug)]
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

impl<T> Default for Record<T>
where
    T: Default,
{
    fn default() -> Self {
        let now = Utc::now();

        Self {
            id: Uuid::new_v4(),
            inner: Default::default(),
            inserted_at: now,
            updated_at: now,
        }
    }
}
