use crate::{datastore, FoundationResult};

#[async_trait::async_trait]
pub trait DeleteProject {
    async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project>;

    async fn delete_project(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<()>;
}

pub struct Request {
    pub slug: String,
}

pub async fn execute(repo: &impl DeleteProject, request: Request) -> FoundationResult<()> {
    let Request { slug } = request;

    let project_record = repo.get_project(slug).await?;

    repo.delete_project(project_record).await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::tests::{project_record_fixture, ProjectRepo};

    #[async_trait::async_trait]
    impl DeleteProject for ProjectRepo {
        async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project> {
            self.find_by_slug(&slug).await
        }

        async fn delete_project(
            &self,
            project_record: datastore::project::Project,
        ) -> FoundationResult<()> {
            let mut project_records = self.records.write().await;

            project_records.remove(&project_record.id);

            Ok(())
        }
    }

    #[tokio::test]
    async fn it_deletes_project() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let repo = ProjectRepo::seed(vec![project_record.clone()]);

        execute(
            &repo,
            Request {
                slug: project_record.slug,
            },
        )
        .await?;

        assert!(repo.records().await.is_empty());

        Ok(())
    }
}
