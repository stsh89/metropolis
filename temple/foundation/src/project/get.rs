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
    use crate::{
        result::FoundationErrorCode,
        tests::{project_record_fixture, ProjectRepo},
        FoundationError,
    };

    #[async_trait::async_trait]
    impl GetProject for ProjectRepo {
        async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project> {
            self.find_by_slug(slug).await
        }
    }

    #[tokio::test]
    async fn it_returns_found_project() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());

        let repo = ProjectRepo::seed(vec![project_record.clone()]);

        let response = execute(
            &repo,
            Request {
                slug: project_record.slug.to_string(),
            },
        )
        .await?;

        assert_eq!(response.project, project_record.into());

        Ok(())
    }

    #[tokio::test]
    async fn it_returns_not_found_error() -> FoundationResult<()> {
        let repo = ProjectRepo::seed(vec![]);

        let Err(error) = execute(&repo,             Request {
            slug: "book-store".to_string(),
        },).await else {
            return Err(FoundationError::internal("expected error, got ok"));
        };

        matches!(error.code(), FoundationErrorCode::NotFound);

        Ok(())
    }
}
