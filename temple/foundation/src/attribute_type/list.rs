//! [`AttributeType`]s listing.

use crate::{
    attribute_type::{AttributeType, ListAttributeTypeRecords},
    FoundationResult,
};

/// List all [`AttributeType`]s.
pub async fn execute(repo: &impl ListAttributeTypeRecords) -> FoundationResult<Vec<AttributeType>> {
    let attribute_types = repo
        .list_attribute_type_records()
        .await?
        .into_iter()
        .map(Into::into)
        .collect();

    Ok(attribute_types)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::attribute_type::tests::{attribute_type_record_fixture, AttributeTypeRepo};

    #[tokio::test]
    async fn it_returns_attribute_types_list() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();
        let record = attribute_type_record_fixture(&repo).await;
        let attribute_type: AttributeType = record.into();

        let attribute_types = execute(&repo).await?;

        assert_eq!(vec![attribute_type], attribute_types);

        Ok(())
    }
}
