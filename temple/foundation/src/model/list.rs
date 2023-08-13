use crate::{datastore, model::Model, FoundationResult};

#[async_trait::async_trait]
pub trait ListModels {
    async fn list_models(
        &self,
        project_slug: &str,
    ) -> FoundationResult<Vec<datastore::model::Model>>;
}

pub struct Request {
    pub project_slug: String,
}

pub struct Response {
    pub models: Vec<Model>,
}

pub async fn execute(repo: &impl ListModels, request: Request) -> FoundationResult<Response> {
    let Request { project_slug } = request;

    let model_records = repo.list_models(&project_slug).await?;

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

    #[async_trait::async_trait]
    impl ListModels for Repo {
        async fn list_models(
            &self,
            project_slug: &str,
        ) -> FoundationResult<Vec<datastore::model::Model>> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            let model_records = self
                .model_repo
                .records()
                .await
                .into_iter()
                .filter(|model_record| model_record.project_id == project_record.id)
                .collect();

            Ok(model_records)
        }
    }

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
