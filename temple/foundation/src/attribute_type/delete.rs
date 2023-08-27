//! [`AttributeType`]'s deletion logic.

use crate::{
    attribute_type::{DeleteAttributeTypeRecord, GetAttributeTypeRecord},
    FoundationError, FoundationResult,
};

/// Delete [`AttributeType`] by slug.
pub async fn execute(
    repo: &(impl GetAttributeTypeRecord + DeleteAttributeTypeRecord),
    slug: &str,
) -> FoundationResult<()> {
    let attribute_type_record = repo
        .get_attribute_type_record(slug)
        .await?
        .ok_or(FoundationError::not_found("Attribute type not found."))?;

    repo.delete_attribute_type_record(attribute_type_record)
        .await
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        attribute_type::tests::{attribute_type_record_fixture, AttributeTypeRepo},
        FoundationErrorCode,
    };

    #[tokio::test]
    async fn it_deletes_attribute_type() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();
        let record = attribute_type_record_fixture(&repo).await;

        execute(&repo, &record.inner.slug).await?;

        assert!(repo.records().await.is_empty());

        Ok(())
    }

    #[tokio::test]
    async fn it_returns_not_found_error() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();

        let error = execute(&repo, "bigint").await.unwrap_err();

        assert!(matches!(error.code(), FoundationErrorCode::NotFound));
        assert_eq!(error.message(), "Attribute type not found.");

        Ok(())
    }
}
