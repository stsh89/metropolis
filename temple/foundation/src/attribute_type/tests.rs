#![cfg(test)]

use super::*;
use crate::{
    datastore::tests::{RecordFactory, Repo},
    Utc, Uuid,
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
impl UpdateAttributeTypeRecord for AttributeTypeRepo {
    async fn update_attribute_type_record(
        &self,
        attribute_type_record: AttributeTypeRecord,
    ) -> FoundationResult<AttributeTypeRecord> {
        let mut attribute_type_records = self.records.write().await;

        let attribute_type_record = AttributeTypeRecord {
            updated_at: Utc::now(),
            ..attribute_type_record
        };

        attribute_type_records.insert(attribute_type_record.id, attribute_type_record.clone());

        Ok(attribute_type_record)
    }
}

#[async_trait::async_trait]
impl DeleteAttributeTypeRecord for AttributeTypeRepo {
    async fn delete_attribute_type_record(
        &self,
        attribute_type_record: AttributeTypeRecord,
    ) -> FoundationResult<()> {
        let mut records = self.records.write().await;

        records.remove(&attribute_type_record.id);

        Ok(())
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
    async fn get_attribute_type_record(
        &self,
        slug: &str,
    ) -> FoundationResult<Option<AttributeTypeRecord>> {
        let maybe_record = self
            .records()
            .await
            .iter()
            .find(|record| record.inner.slug == slug)
            .cloned();

        Ok(maybe_record)
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
