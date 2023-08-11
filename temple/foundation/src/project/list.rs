use crate::{datastore, project::Project, FoundationResult};

#[async_trait::async_trait]
pub trait ListProjects {
    async fn list_projects(&self) -> FoundationResult<Vec<datastore::project::Project>>;
}

pub struct Response {
    pub projects: Vec<Project>,
}

pub async fn execute(repo: &impl ListProjects) -> FoundationResult<Response> {
    let projec_records = repo.list_projects().await?;

    let response = Response {
        projects: projec_records.into_iter().map(Into::into).collect(),
    };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{project::tests::ProjectRepo, Utc};

    #[async_trait::async_trait]
    impl ListProjects for ProjectRepo {
        async fn list_projects(&self) -> FoundationResult<Vec<datastore::project::Project>> {
            let project_records = self
                .projects
                .read()
                .await
                .values()
                .filter(|project| project.archived_at.is_none())
                .cloned()
                .collect();

            Ok(project_records)
        }
    }

    fn projec_records() -> Vec<datastore::project::Project> {
        vec![
            datastore::project::Project {
                name: "Food service".to_string(),
                slug: "food-service".to_string(),
                archived_at: Some(Utc::now()),
                ..Default::default()
            },
            datastore::project::Project {
                name: "Book store".to_string(),
                slug: "book-store".to_string(),
                ..Default::default()
            },
        ]
    }

    #[tokio::test]
    async fn it_returns_not_archived_projects() -> FoundationResult<()> {
        let repo = ProjectRepo::initialize(projec_records());
        let response = execute(&repo).await?;

        assert_eq!(
            response.projects,
            vec![Project {
                description: None,
                name: "Book store".to_string(),
                slug: "book-store".to_string()
            }]
        );

        Ok(())
    }
}
