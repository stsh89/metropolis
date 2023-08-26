//! Get single [`AttributeType`].

use crate::{
    attribute_type::{AttributeType, GetAttributeTypeRecord},
    FoundationResult,
};

/// Find [`AttributeType`] by slug.
pub async fn execute(
    repo: &impl GetAttributeTypeRecord,
    slug: &str,
) -> FoundationResult<AttributeType> {
    let attribute_type = repo.get_attribute_type_record(slug).await?.into();

    Ok(attribute_type)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        attribute_type::tests::{attribute_type_record_fixture, AttributeTypeRepo},
        FoundationError, FoundationErrorCode,
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

        Ok(())
    }
}
