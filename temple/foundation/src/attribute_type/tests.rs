#![cfg(test)]

use super::*;
use crate::datastore::tests::{RecordFactory, Repo};

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
impl ListAttributeTypeRecords for AttributeTypeRepo {
    async fn list_attribute_type_records(&self) -> FoundationResult<Vec<AttributeTypeRecord>> {
        Ok(self.records().await)
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
