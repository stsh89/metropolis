//! Get single [`AttributeType`].

use super::{validate_slug, AttributeType, GetAttributeTypeRecord};
use crate::{FoundationError, FoundationResult};

/// Find [`AttributeType`] by slug.
pub async fn execute(
    repo: &impl GetAttributeTypeRecord,
    slug: &str,
) -> FoundationResult<AttributeType> {
    validate_slug(slug)?;

    let attribute_type = repo
        .get_attribute_type_record(slug)
        .await?
        .ok_or(FoundationError::not_found("attribute type not found"))?
        .into();

    Ok(attribute_type)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        attribute_type::tests::{attribute_type_record_fixture, AttributeTypeRepo},
        FoundationErrorCode,
    };

    #[tokio::test]
    async fn it_returns_attribute_type() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();
        let record = attribute_type_record_fixture(&repo).await;
        let attribute_type: AttributeType = record.into();

        let found_attribute_type = execute(&repo, &attribute_type.slug).await?;

        assert_eq!(found_attribute_type, attribute_type);

        Ok(())
    }

    #[tokio::test]
    async fn it_returns_not_found_error() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();

        let error = execute(&repo, "bigint").await.unwrap_err();

        assert!(matches!(error.code(), FoundationErrorCode::NotFound));
        assert_eq!(error.message(), "attribute type not found");

        Ok(())
    }

    #[tokio::test]
    async fn it_returns_invalid_argument_error() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();

        let error = execute(&repo, "").await.unwrap_err();

        assert!(matches!(error.code(), FoundationErrorCode::InvalidArgument));
        assert_eq!(error.message(), "slug can't be blank");

        Ok(())
    }
}
