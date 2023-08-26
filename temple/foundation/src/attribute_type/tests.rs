#![cfg(test)]

use super::*;
use crate::{
    datastore::tests::{RecordFactory, Repo},
    FoundationError, Utc, Uuid,
};

struct AttributeTypeFactory {}

impl AttributeTypeFactory {
    fn build() -> AttributeType {
        AttributeType {
            description: Some("Large-range integer".to_string()),
            name: "Bigint".to_string(),
            slug: "bigint".to_string(),
        }
    }
}

pub type AttributeTypeRepo = Repo<AttributeType>;

#[async_trait::async_trait]
impl CreateAttributeTypeRecord for AttributeTypeRepo {
    async fn create_attribute_type_record(
        &self,
        attribute_type: AttributeType,
    ) -> FoundationResult<AttributeTypeRecord> {
        let now = Utc::now();

        let attribute_type_record = AttributeTypeRecord {
            id: Uuid::new_v4(),
            inner: attribute_type,
            inserted_at: now,
            updated_at: now,
        };

        self.save(attribute_type_record.clone()).await;

        Ok(attribute_type_record)
    }
}

#[async_trait::async_trait]
impl ListAttributeTypeRecords for AttributeTypeRepo {
    async fn list_attribute_type_records(&self) -> FoundationResult<Vec<AttributeTypeRecord>> {
        Ok(self.records().await)
    }
}

#[async_trait::async_trait]
impl GetAttributeTypeRecord for AttributeTypeRepo {
    async fn get_attribute_type_record(&self, slug: &str) -> FoundationResult<AttributeTypeRecord> {
        let record = self
            .records()
            .await
            .iter()
            .find(|record| record.inner.slug == slug)
            .ok_or(FoundationError::not_found("AttributeType not found."))?
            .to_owned();

        Ok(record)
    }
}

pub async fn attribute_type_record_fixture(repo: &AttributeTypeRepo) -> AttributeTypeRecord {
    let attribute_type = AttributeTypeFactory::build();
    let attribute_type_record = RecordFactory::build(&attribute_type);
    repo.save(attribute_type_record.clone()).await;

    attribute_type_record
}

#[test]
fn it_converts_record_into_attribute_type() {
    let attribute_type = AttributeTypeFactory::build();
    let attribute_type_record = RecordFactory::build(&attribute_type);

    assert_eq!(
        Into::<AttributeType>::into(attribute_type_record),
        attribute_type
    );
}
