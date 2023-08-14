use crate::{datastore, FoundationResult};

#[async_trait::async_trait]
pub trait RestoreProject {
    async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project>;

    async fn restore_project(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<()>;
}

pub struct Request {
    pub slug: String,
}

pub async fn execute(repo: &impl RestoreProject, request: Request) -> FoundationResult<()> {
    let Request { slug } = request;

    let project_record = repo.get_project(slug).await?;

    repo.restore_project(project_record).await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        tests::{project_record_fixture, ProjectRecordFixture, ProjectRepo},
        Utc,
    };

    #[async_trait::async_trait]
    impl RestoreProject for ProjectRepo {
        async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project> {
            self.find_by_slug(&slug).await
        }

        async fn restore_project(
            &self,
            project_record: datastore::project::Project,
        ) -> FoundationResult<()> {
            let mut found_project_record = self.get(project_record.id).await?;

            let mut project_records = self.records.write().await;

            found_project_record.archived_at = None;

            project_records.insert(found_project_record.id, found_project_record.clone());

            Ok(())
        }
    }

    #[tokio::test]
    async fn it_removes_archivation_mark_from_project() -> FoundationResult<()> {
        let project_record = project_record_fixture(ProjectRecordFixture {
            archived_at: Some(Utc::now()),
            ..Default::default()
        });

        let repo = ProjectRepo::seed(vec![
            project_record.clone(),
            project_record_fixture(ProjectRecordFixture {
                name: Some("Food service".to_string()),
                slug: Some("food-service".to_string()),
                archived_at: Some(Utc::now()),
                ..Default::default()
            }),
        ]);

        execute(
            &repo,
            Request {
                slug: project_record.slug.clone(),
            },
        )
        .await?;

        assert!(repo
            .find_by_slug(&project_record.slug)
            .await?
            .archived_at
            .is_none(),);

        assert!(repo
            .find_by_slug("food-service")
            .await?
            .archived_at
            .is_some(),);

        Ok(())
    }
}
