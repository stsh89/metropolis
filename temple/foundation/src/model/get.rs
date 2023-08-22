use crate::{
    datastore,
    model::{GetModelOverviewRecord, ModelOverview},
    FoundationResult,
};

pub struct GetModelResponse {
    pub model: datastore::model::Model,
    pub associations: Vec<datastore::model::Association>,
    pub attributes: Vec<datastore::model::Attribute>,
}

pub struct Request {
    pub project_slug: String,
    pub model_slug: String,
}

pub struct Response {
    pub model_overview: ModelOverview,
}

pub async fn execute(
    repo: &impl GetModelOverviewRecord,
    request: Request,
) -> FoundationResult<Response> {
    let Request {
        project_slug,
        model_slug,
    } = request;

    let model_overview: ModelOverview = repo
        .get_model_overview_record(&project_slug, &model_slug)
        .await?
        .into();

    let response = Response { model_overview };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::{tests::Repo, Association, Attribute},
        tests::{
            model_association_record_fixture, model_attribute_record_fixture, model_record_fixture,
            project_record_fixture, ModelAssociationRecordFixture, ModelAssociationRepo,
            ModelAttributeRecordFixture, ModelAttributeRepo, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[tokio::test]
    async fn it_returns_model_with_attributes_and_associations() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            ..Default::default()
        });
        let model_attribute_record = model_attribute_record_fixture(ModelAttributeRecordFixture {
            model_id: Some(model_record.id),
            ..Default::default()
        });
        let associated_model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            name: Some("Publisher".to_string()),
            slug: Some("publisher".to_string()),
            ..Default::default()
        });
        let model_association_record =
            model_association_record_fixture(ModelAssociationRecordFixture {
                model_id: Some(model_record.id),
                associated_model: Some(associated_model_record.clone()),
                ..Default::default()
            });

        let project_repo = ProjectRepo::seed(vec![project_record.clone()]);
        let model_repo =
            ModelRepo::seed(vec![model_record.clone(), associated_model_record.clone()]);
        let model_attribute_repo = ModelAttributeRepo::seed(vec![model_attribute_record.clone()]);
        let model_association_repo =
            ModelAssociationRepo::seed(vec![model_association_record.clone()]);

        let repo = Repo {
            project_repo,
            model_repo,
            model_attribute_repo,
            model_association_repo,
        };

        let response = execute(
            &repo,
            Request {
                project_slug: project_record.slug.to_string(),
                model_slug: model_record.slug.to_string(),
            },
        )
        .await?;

        assert_eq!(response.model_overview.model, model_record.into());
        assert_eq!(
            response.model_overview.attributes,
            vec![model_attribute_record]
                .into_iter()
                .map(Into::into)
                .collect::<Vec<Attribute>>()
        );
        assert_eq!(
            response.model_overview.associations,
            vec![model_association_record]
                .into_iter()
                .map(Into::into)
                .collect::<Vec<Association>>()
        );

        Ok(())
    }
}
