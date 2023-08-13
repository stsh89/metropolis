use crate::{datastore, FoundationResult};

#[async_trait::async_trait]
pub trait DeleteModel {
    async fn get_model(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::Model>;

    async fn delete_model(&self, attribute: datastore::model::Model) -> FoundationResult<()>;
}

pub struct Request {
    pub project_slug: String,
    pub model_slug: String,
}

pub async fn execute(repo: &impl DeleteModel, request: Request) -> FoundationResult<()> {
    let Request {
        project_slug,
        model_slug,
    } = request;

    let model_record = repo.get_model(&project_slug, &model_slug).await?;

    repo.delete_model(model_record).await?;

    Ok(())
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
    impl DeleteModel for Repo {
        async fn get_model(
            &self,
            project_slug: &str,
            model_slug: &str,
        ) -> FoundationResult<datastore::model::Model> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            self.model_repo
                .find_by_slug(project_record.id, model_slug)
                .await
        }

        async fn delete_model(
            &self,
            model_record: datastore::model::Model,
        ) -> FoundationResult<()> {
            let mut model_records = self.model_repo.records.write().await;

            model_records.remove(&model_record.id);

            Ok(())
        }
    }

    #[tokio::test]
    async fn it_deletes_a_model() -> FoundationResult<()> {
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

        execute(
            &repo,
            Request {
                project_slug: project_record.slug,
                model_slug: model_record.slug,
            },
        )
        .await?;

        assert!(repo.model_repo.records().await.is_empty());

        Ok(())
    }
}
