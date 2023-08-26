//! [`AttributeType`]'s creation.

use super::{AttributeType, CreateAttributeTypeRecord};
use crate::{util, FoundationResult};

pub struct Request {
    pub name: String,
    pub description: String,
}

/// Create an [`AttributeType`] with the required attributes.
pub async fn execute(
    repo: &impl CreateAttributeTypeRecord,
    request: Request,
) -> FoundationResult<AttributeType> {
    validate_request(&request)?;

    let Request { name, description } = request;

    let attribute_type = repo
        .create_attribute_type_record(AttributeType {
            description: util::string::optional(&description),
            slug: util::slug::sluggify(&name),
            name,
        })
        .await?
        .into();

    Ok(attribute_type)
}

fn validate_request(request: &Request) -> FoundationResult<()> {
    let Request {
        name,
        description: _,
    } = request;

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
    use crate::{attribute_type::tests::AttributeTypeRepo, FoundationError};

    #[tokio::test]
    async fn it_creates_attribute_type() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();

        let attribute_type = execute(
            &repo,
            Request {
                name: "Bigint".to_string(),
                description: "Large-range integer".to_string(),
            },
        )
        .await?;

        assert_eq!(
            repo.records()
                .await
                .into_iter()
                .map(Into::<AttributeType>::into)
                .collect::<Vec<AttributeType>>(),
            vec![attribute_type.clone()]
        );

        assert_eq!(
            attribute_type,
            AttributeType {
                name: "Bigint".to_string(),
                description: Some("Large-range integer".to_string()),
                slug: "bigint".to_string(),
            }
        );

        Ok(())
    }

    #[tokio::test]
    async fn it_converts_empty_description_to_none() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();

        let AttributeType { description, .. } = execute(
            &repo,
            Request {
                name: "Bigint".to_string(),
                description: "".to_string(),
            },
        )
        .await?;

        assert_eq!(description, None);

        Ok(())
    }

    #[tokio::test]
    async fn it_validates_name() -> FoundationResult<()> {
        let repo = AttributeTypeRepo::new();

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
                Request {
                    name: name,
                    description: "".to_string(),
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
