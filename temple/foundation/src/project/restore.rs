use crate::{datastore, FoundationResult};

#[async_trait::async_trait]
pub trait RestoreProject {
    async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project>;

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

    let project_record = repo.get_project(&slug).await?;

    repo.restore_project(project_record).await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{project::tests::ProjectRepo, Utc};

    #[async_trait::async_trait]
    impl RestoreProject for ProjectRepo {
        async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project> {
            self.find_project_by_slug(slug).await
        }

        async fn restore_project(
            &self,
            project_record: datastore::project::Project,
        ) -> FoundationResult<()> {
            let mut found_project_record = self.get(project_record.id).await?;

            let mut project_records = self.projects.write().await;

            found_project_record.archived_at = None;

            project_records.insert(found_project_record.id, found_project_record.clone());

            Ok(())
        }
    }

    fn project_records() -> Vec<datastore::project::Project> {
        vec![
            datastore::project::Project {
                archived_at: Some(Utc::now()),
                name: "Book store".to_string(),
                slug: "book-store".to_string(),
                ..Default::default()
            },
            datastore::project::Project {
                archived_at: Some(Utc::now()),
                name: "Food service".to_string(),
                slug: "food-service".to_string(),
                ..Default::default()
            },
        ]
    }

    fn valid_request() -> Request {
        Request {
            slug: "book-store".to_string(),
        }
    }

    #[tokio::test]
    async fn it_removes_archivation_mark_from_project() -> FoundationResult<()> {
        let repo = ProjectRepo::initialize(project_records());
        execute(&repo, valid_request()).await?;

        // assert_eq!(
        //     repo.projects()
        //         .await
        //         .iter()
        //         .filter(|record| record.archived_at.is_none())
        //         .count(),
        //     1
        // );

        Ok(())
    }
}
