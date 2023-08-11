use crate::{datastore, project::Project, util, FoundationResult};

#[async_trait::async_trait]
pub trait CreateProject {
    async fn create_project(
        &self,
        project: Project,
    ) -> FoundationResult<datastore::project::Project>;
}

pub struct Request {
    pub name: String,
    pub description: String,
}

pub struct Response {
    pub project: Project,
}

pub async fn execute(repo: &impl CreateProject, request: Request) -> FoundationResult<Response> {
    let Request { name, description } = request;

    let project_record = repo
        .create_project(Project {
            slug: util::slug::sluggify(&name),
            name,
            description: util::string::optional(&description),
        })
        .await?;

    let response = Response {
        project: project_record.into(),
    };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::project::tests::ProjectRepo;

    #[async_trait::async_trait]
    impl CreateProject for ProjectRepo {
        async fn create_project(
            &self,
            project: Project,
        ) -> FoundationResult<datastore::project::Project> {
            let Project {
                description,
                name,
                slug,
            } = project;

            let mut project_records = self.projects.write().await;

            let project_record = datastore::project::Project {
                description: description.unwrap_or_default(),
                name,
                slug,
                ..Default::default()
            };

            project_records.insert(project_record.id, project_record.clone());

            Ok(project_record)
        }
    }

    fn valid_request() -> Request {
        Request {
            name: "Book store".to_string(),
            description: "Buy and sell books platform".to_string(),
        }
    }

    #[tokio::test]
    async fn it_creates_a_project() -> FoundationResult<()> {
        let repo = ProjectRepo::initialize(vec![]);
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
                description: Some("Buy and sell books platform".to_string()),
                name: "Book store".to_string(),
                slug: "book-store".to_string()
            }
        );

        Ok(())
    }
}
