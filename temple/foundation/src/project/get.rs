use crate::{datastore, project::Project, FoundationResult};

#[async_trait::async_trait]
pub trait GetProject {
    async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project>;
}

pub struct Request {
    pub slug: String,
}

pub struct Response {
    pub project: Project,
}

pub async fn execute(repo: &impl GetProject, request: Request) -> FoundationResult<Response> {
    let Request { slug } = request;

    let project_record = repo.get_project(&slug).await?;

    let response = Response {
        project: project_record.into(),
    };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{project::tests::ProjectRepo, result::FoundationErrorCode, FoundationError};

    #[async_trait::async_trait]
    impl GetProject for ProjectRepo {
        async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project> {
            self.find_project_by_slug(slug).await
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

    fn invalid_request() -> Request {
        Request {
            slug: "food-service".to_string(),
        }
    }

    #[tokio::test]
    async fn it_returns_found_project() -> FoundationResult<()> {
        let repo = ProjectRepo::initialize(project_records());
        let response = execute(&repo, valid_request()).await?;

        assert_eq!(
            repo.projects()
                .await
                .into_iter()
                .map(Into::<Project>::into)
                .collect::<Vec<Project>>(),
            vec![response.project.clone()]
        );

        assert_eq!(
            response.project,
            Project {
                description: None,
                name: "Book store".to_string(),
                slug: "book-store".to_string()
            }
        );

        Ok(())
    }

    #[tokio::test]
    async fn it_returns_not_found_error() -> FoundationResult<()> {
        let repo = ProjectRepo::initialize(project_records());

        let Err(error) = execute(&repo, invalid_request()).await else {
            return Err(FoundationError::internal("expected error, got ok"));
        };

        matches!(error.code(), FoundationErrorCode::NotFound);

        Ok(())
    }
}
