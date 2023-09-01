use crate::{
    attribute_type::GetAttributeTypeRecord,
    model::{Attribute, CreateModelAttributeRecord, GetModelRecord},
    util, FoundationError, FoundationResult,
};

pub struct Request {
    pub project_slug: String,
    pub model_slug: String,
    pub description: String,
    pub name: String,
    pub attribute_type_slug: String,
}

pub struct Response {
    pub model_attribute: Attribute,
}

pub async fn execute(
    repo: &(impl GetModelRecord + CreateModelAttributeRecord + GetAttributeTypeRecord),
    request: Request,
) -> FoundationResult<Response> {
    let Request {
        project_slug,
        model_slug,
        description,
        attribute_type_slug,
        name,
    } = request;

    let model_record = repo.get_model_record(&project_slug, &model_slug).await?;

    let attribute_type_record = repo
        .get_attribute_type_record(&attribute_type_slug)
        .await?
        .ok_or(FoundationError::not_found("attribute type not found"))?;

    let model_attribute_record = repo
        .create_model_attribute_record(
            model_record,
            attribute_type_record.clone(),
            Attribute {
                description: util::string::optional(&description),
                r#type: attribute_type_record.into(),
                name,
            },
        )
        .await?;

    let response = Response {
        model_attribute: model_attribute_record.into(),
    };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        attribute_type::tests::{attribute_type_record_fixture, AttributeTypeRepo},
        model::tests::Repo,
        tests::{
            model_record_fixture, project_record_fixture, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[tokio::test]
    async fn it_creates_a_model_attribute() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            ..Default::default()
        });

        let project_repo = ProjectRepo::seed(vec![project_record.clone()]);
        let model_repo = ModelRepo::seed(vec![model_record.clone()]);
        let attribute_type_repo = AttributeTypeRepo::new();
        let attribute_type_record = attribute_type_record_fixture(&attribute_type_repo).await;

        let repo = Repo {
            project_repo,
            model_repo,
            attribute_type_repo,
            ..Default::default()
        };

        let response = execute(
            &repo,
            Request {
                project_slug: project_record.slug,
                model_slug: model_record.slug,
                description: "The Title of the Book".to_string(),
                name: "Title".to_string(),
                attribute_type_slug: attribute_type_record.inner.slug.to_owned(),
            },
        )
        .await?;

        assert_eq!(
            repo.model_attribute_repo
                .records()
                .await
                .into_iter()
                .map(Into::<Attribute>::into)
                .collect::<Vec<Attribute>>(),
            vec![response.model_attribute.clone()]
        );

        assert_eq!(
            response.model_attribute,
            Attribute {
                description: Some("The Title of the Book".to_string()),
                r#type: attribute_type_record.into(),
                name: "Title".to_string(),
            }
        );

        let model_attribute_record = repo
            .model_attribute_repo
            .find_by_name(model_record.id, "Title")
            .await?;

        assert_eq!(model_record.id, model_attribute_record.model_id);

        Ok(())
    }
}
