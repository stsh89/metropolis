use crate::{datastore, FoundationResult};

#[async_trait::async_trait]
pub trait DeleteModelAssociation {
    async fn get_model_association(
        &self,
        project_slug: &str,
        model_slug: &str,
        name: &str,
    ) -> FoundationResult<datastore::model::Association>;

    async fn delete_model_association(
        &self,
        association: datastore::model::Association,
    ) -> FoundationResult<()>;
}

pub struct Request {
    pub project_slug: String,
    pub model_slug: String,
    pub model_association_name: String,
}

pub async fn execute(repo: &impl DeleteModelAssociation, request: Request) -> FoundationResult<()> {
    let Request {
        project_slug,
        model_slug,
        model_association_name,
    } = request;

    let model_association_record = repo
        .get_model_association(&project_slug, &model_slug, &model_association_name)
        .await?;

    repo.delete_model_association(model_association_record)
        .await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::tests::Repo,
        tests::{
            model_association_record_fixture, model_record_fixture, project_record_fixture,
            ModelAssociationRecordFixture, ModelAssociationRepo, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[async_trait::async_trait]
    impl DeleteModelAssociation for Repo {
        async fn get_model_association(
            &self,
            project_slug: &str,
            model_slug: &str,
            model_association_name: &str,
        ) -> FoundationResult<datastore::model::Association> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            let model_record = self
                .model_repo
                .find_by_slug(project_record.id, model_slug)
                .await?;

            self.model_association_repo
                .find_by_name(model_record.id, model_association_name)
                .await
        }

        async fn delete_model_association(
            &self,
            model_association_record: datastore::model::Association,
        ) -> FoundationResult<()> {
            let mut model_association_records = self.model_association_repo.records.write().await;

            model_association_records.remove(&model_association_record.id);

            Ok(())
        }
    }

    #[tokio::test]
    async fn it_deletes_a_model_association() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
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
        let model_association_repo =
            ModelAssociationRepo::seed(vec![model_association_record.clone()]);

        let repo = Repo {
            project_repo,
            model_repo,
            model_association_repo,
            ..Default::default()
        };

        execute(
            &repo,
            Request {
                project_slug: project_record.slug,
                model_slug: model_record.slug,
                model_association_name: "Publisher".to_string(),
            },
        )
        .await?;

        assert!(repo.model_association_repo.records().await.is_empty());

        Ok(())
    }
}
