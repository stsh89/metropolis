use crate::{datastore, FoundationResult};

#[async_trait::async_trait]
pub trait DeleteProject {
    async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project>;

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

    let project_record = repo.get_project(&slug).await?;

    repo.delete_project(project_record).await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::project::tests::ProjectRepo;

    #[async_trait::async_trait]
    impl DeleteProject for ProjectRepo {
        async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project> {
            self.get_project(slug).await
        }

        async fn delete_project(
            &self,
            project_record: datastore::project::Project,
        ) -> FoundationResult<()> {
            let mut project_records = self.projects.write().await;

            project_records.remove(&project_record.id);

            Ok(())
        }
    }

    fn project_records() -> Vec<datastore::project::Project> {
        vec![datastore::project::Project {
            name: "Book store".to_string(),
            slug: "book-store".to_string(),
            ..Default::default()
        }]
    }

    fn valid_request() -> Request {
        Request {
            slug: "book-store".to_string(),
        }
    }

    #[tokio::test]
    async fn it_deletes_project() -> FoundationResult<()> {
        let repo = ProjectRepo::initialize(project_records());
        execute(&repo, valid_request()).await?;

        assert!(repo.projects().await.is_empty());

        Ok(())
    }
}
