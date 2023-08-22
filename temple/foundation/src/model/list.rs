use crate::{
    model::{ListModelRecords, Model},
    FoundationResult,
};

pub struct Request {
    pub project_slug: String,
}

pub struct Response {
    pub models: Vec<Model>,
}

pub async fn execute(repo: &impl ListModelRecords, request: Request) -> FoundationResult<Response> {
    let Request { project_slug } = request;

    let model_records = repo.list_model_records(&project_slug).await?;

    let response = Response {
        models: model_records.into_iter().map(Into::into).collect(),
    };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::tests::Repo,
        tests::{
            model_record_fixture, project_record_fixture, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[tokio::test]
    async fn it_returns_a_list_of_project_models() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            ..Default::default()
        });

        let project_repo = ProjectRepo::seed(vec![project_record.clone()]);
        let model_repo = ModelRepo::seed(vec![model_record.clone()]);

        let repo = Repo {
            project_repo,
            model_repo,
            ..Default::default()
        };

        let response = execute(
            &repo,
            Request {
                project_slug: project_record.slug,
            },
        )
        .await?;

        assert_eq!(response.models, vec![model_record.into()]);

        Ok(())
    }
}
