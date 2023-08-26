#![cfg(test)]

use super::*;
use crate::Utc;

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

struct RecordFactory {}

impl RecordFactory {
    fn build<T>(inner: &T) -> Record<T>
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
