#![cfg(test)]

use super::*;
use crate::Utc;
use std::collections::HashMap;
use tokio::sync::RwLock;

#[derive(Clone, Debug, PartialEq)]
struct Book {
    title: String,
    language: String,
}

struct BookFactory {}

impl BookFactory {
    fn build() -> Book {
        Book {
            title: "Harry Potter and the Sorcerer's Stone".to_string(),
            language: "English".to_string(),
        }
    }
}

pub struct RecordFactory {}

pub struct Repo<T> {
    pub records: RwLock<HashMap<Uuid, Record<T>>>,
}

impl<T> Repo<T> {
    pub fn new() -> Self {
        Self {
            records: Default::default(),
        }
    }

    pub async fn records(&self) -> Vec<Record<T>>
    where
        T: Clone,
    {
        self.records.read().await.values().cloned().collect()
    }

    pub async fn save(&self, record: Record<T>) {
        let mut records = self.records.write().await;

        records.insert(record.id, record);
    }
}

impl RecordFactory {
    pub fn build<T>(inner: &T) -> Record<T>
    where
        T: Clone,
    {
        let now = Utc::now();

        Record {
            id: Uuid::new_v4(),
            inner: inner.to_owned(),
            inserted_at: now,
            updated_at: now,
        }
    }
}

#[test]
fn it_returns_stored_data() {
    let book = BookFactory::build();
    let record = RecordFactory::build(&book);

    assert_eq!(record.into_inner(), book);
}
