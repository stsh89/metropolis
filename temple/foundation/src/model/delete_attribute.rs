use crate::{datastore, FoundationResult};

#[async_trait::async_trait]
pub trait DeleteModelAttribute {
    async fn get_model_attribute(
        &self,
        project_slug: &str,
        model_slug: &str,
        name: &str,
    ) -> FoundationResult<datastore::model::Attribute>;

    async fn delete_model_attribute(
        &self,
        attribute: datastore::model::Attribute,
    ) -> FoundationResult<()>;
}

pub struct Request {
    pub project_slug: String,
    pub model_slug: String,
    pub model_attribute_name: String,
}

pub async fn execute(repo: &impl DeleteModelAttribute, request: Request) -> FoundationResult<()> {
    let Request {
        project_slug,
        model_slug,
        model_attribute_name,
    } = request;

    let model_attribute_record = repo
        .get_model_attribute(&project_slug, &model_slug, &model_attribute_name)
        .await?;

    repo.delete_model_attribute(model_attribute_record).await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::tests::Repo,
        tests::{
            model_attribute_record_fixture, model_record_fixture, project_record_fixture,
            ModelAttributeRecordFixture, ModelAttributeRepo, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[async_trait::async_trait]
    impl DeleteModelAttribute for Repo {
        async fn get_model_attribute(
            &self,
            project_slug: &str,
            model_slug: &str,
            model_attribute_name: &str,
        ) -> FoundationResult<datastore::model::Attribute> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            let model_record = self
                .model_repo
                .find_by_slug(project_record.id, model_slug)
                .await?;

            self.model_attribute_repo
                .find_by_name(model_record.id, model_attribute_name)
                .await
        }

        async fn delete_model_attribute(
            &self,
            model_attribute_record: datastore::model::Attribute,
        ) -> FoundationResult<()> {
            let mut model_attribute_records = self.model_attribute_repo.records.write().await;

            model_attribute_records.remove(&model_attribute_record.id);

            Ok(())
        }
    }

    #[tokio::test]
    async fn it_deletes_a_model_attribute() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            ..Default::default()
        });
        let model_attribute_record = model_attribute_record_fixture(ModelAttributeRecordFixture {
            model_id: Some(model_record.id),
            ..Default::default()
        });

        let project_repo = ProjectRepo::seed(vec![project_record.clone()]);
        let model_repo = ModelRepo::seed(vec![model_record.clone()]);
        let model_attribute_repo = ModelAttributeRepo::seed(vec![model_attribute_record.clone()]);

        let repo = Repo {
            project_repo,
            model_repo,
            model_attribute_repo,
            ..Default::default()
        };

        execute(
            &repo,
            Request {
                project_slug: project_record.slug,
                model_slug: model_record.slug,
                model_attribute_name: "Title".to_string(),
            },
        )
        .await?;

        assert!(repo.model_attribute_repo.records().await.is_empty());

        Ok(())
    }
}
