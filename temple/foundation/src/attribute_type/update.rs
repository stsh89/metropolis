//! [`AttributeType`]'s update logic.

use super::{
    AttributeType, AttributeTypeRecord, GetAttributeTypeRecord, UpdateAttributeTypeRecord,
};
use crate::{util, FoundationError, FoundationResult};

/// Update [`AttributeType`]'s values.
pub async fn execute(
    repo: &(impl GetAttributeTypeRecord + UpdateAttributeTypeRecord),
    attribute_type: AttributeType,
) -> FoundationResult<AttributeType> {
    validate_attribute_type(&attribute_type)?;

    let AttributeType {
        description,
        name,
        slug,
    } = attribute_type;

    let attribute_type_record = repo
        .get_attribute_type_record(&slug)
        .await?
        .ok_or(FoundationError::not_found("Attribute type not found."))?;

    let attribute_type_record = repo
        .update_attribute_type_record(AttributeTypeRecord {
            inner: AttributeType {
                slug: util::slug::sluggify(&name),
                description,
                name,
            },
            ..attribute_type_record
        })
        .await?;

    Ok(attribute_type_record.into())
}

fn validate_attribute_type(attribute_type: &AttributeType) -> FoundationResult<()> {
    let AttributeType {
        name,
        description: _,
        slug: _,
    } = attribute_type;

    let validation_errors = util::validator::Validator::new()
        .validate_required("name", name)
        .validate_max_length("name", name, 50)
        .validate();

    if validation_errors.is_empty() {
        return Ok(());
    }

    Err(validation_errors.first().cloned().unwrap().into())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        attribute_type::tests::{attribute_type_record_fixture, AttributeTypeRepo},
        FoundationErrorCode,
    };

    #[tokio::test]
    async fn it_updates_attribute_type() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();
        let record = attribute_type_record_fixture(&repo).await;
        let attribute_type: AttributeType = record.into();

        let attribute_type = execute(
            &repo,
            AttributeType {
                description: Some("Timestamp without a timezone".to_string()),
                name: "Timestamp".to_string(),
                slug: attribute_type.slug.clone(),
            },
        )
        .await?;

        assert_eq!(
            repo.records().await.first().unwrap().inner,
            AttributeType {
                name: "Timestamp".to_string(),
                description: Some("Timestamp without a timezone".to_string()),
                slug: "timestamp".to_string(),
            }
        );

        assert_eq!(
            attribute_type,
            AttributeType {
                name: "Timestamp".to_string(),
                description: Some("Timestamp without a timezone".to_string()),
                slug: "timestamp".to_string(),
            }
        );

        Ok(())
    }

    #[tokio::test]
    async fn it_returns_not_found_error() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();

        let error = execute(
            &repo,
            AttributeType {
                description: None,
                name: "Bigint".to_string(),
                slug: "bigint".to_string(),
            },
        )
        .await
        .unwrap_err();

        assert!(matches!(error.code(), FoundationErrorCode::NotFound));
        assert_eq!(error.message(), "Attribute type not found.");

        Ok(())
    }

    #[tokio::test]
    async fn it_validates_name() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();
        let record = attribute_type_record_fixture(&repo).await;
        let attribute_type: AttributeType = record.into();

        let test_table = [
            (
                "".to_string(),
                FoundationError::invalid_argument("name can't be blank"),
            ),
            (
                "x".repeat(51),
                FoundationError::invalid_argument("name is too long, maximum length is 50 bytes"),
            ),
        ];

        for (name, expected_error) in test_table {
            let error = execute(
                &repo,
                AttributeType {
                    description: attribute_type.description.clone(),
                    name: name,
                    slug: attribute_type.slug.clone(),
                },
            )
            .await
            .unwrap_err();

            assert_eq!(error.code(), expected_error.code());
            assert_eq!(error.message(), expected_error.message());
        }

        Ok(())
    }
}
