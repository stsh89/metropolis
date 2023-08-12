use crate::{datastore, model::Model, util, FoundationResult};

#[async_trait::async_trait]
pub trait CreateModel {
    async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project>;

    async fn create_model(
        &self,
        project: datastore::project::Project,
        model: Model,
    ) -> FoundationResult<datastore::model::Model>;
}

pub struct Request {
    pub project_slug: String,
    pub name: String,
    pub description: String,
}

pub struct Response {
    pub model: Model,
}

pub async fn execute(repo: &impl CreateModel, request: Request) -> FoundationResult<Response> {
    let Request {
        project_slug,
        name,
        description,
    } = request;

    let project_record = repo.get_project(&project_slug).await?;

    let model_record = repo
        .create_model(
            project_record,
            Model {
                slug: util::slug::sluggify(&name),
                name,
                description: util::string::optional(&description),
            },
        )
        .await?;

    let response = Response {
        model: model_record.into(),
    };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::tests::Repo,
        tests::{project_record_fixture, ModelRepo, ProjectRepo},
    };

    #[async_trait::async_trait]
    impl CreateModel for Repo {
        async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project> {
            self.project_repo.find_by_slug(slug).await
        }

        async fn create_model(
            &self,
            project_record: datastore::project::Project,
            model: Model,
        ) -> FoundationResult<datastore::model::Model> {
            let Model {
                description,
                name,
                slug,
            } = model;

            let mut model_records = self.model_repo.records.write().await;

            let model_record = datastore::model::Model {
                project_id: project_record.id,
                description: description.unwrap_or_default(),
                name,
                slug,
                ..Default::default()
            };

            model_records.insert(model_record.id, model_record.clone());

            Ok(model_record)
        }
    }

    #[tokio::test]
    async fn it_creates_a_model() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let project_repo = ProjectRepo::seed(vec![project_record.clone()]);
        let model_repo = ModelRepo::seed(vec![]);

        let repo = Repo {
            project_repo,
            model_repo,
        };

        let response = execute(
            &repo,
            Request {
                project_slug: "book-store".to_string(),
                name: "Book".to_string(),
                description: "".to_string(),
            },
        )
        .await?;

        assert_eq!(
            repo.model_repo
                .records()
                .await
                .into_iter()
                .map(Into::<Model>::into)
                .collect::<Vec<Model>>(),
            vec![response.model.clone()]
        );

        assert_eq!(
            response.model,
            Model {
                description: None,
                name: "Book".to_string(),
                slug: "book".to_string()
            }
        );

        let model_record = repo
            .model_repo
            .find_by_slug(project_record.id, "book")
            .await?;

        assert_eq!(project_record.id, model_record.project_id);

        Ok(())
    }
}
