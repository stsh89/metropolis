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
    use crate::{
        tests::{project_record_fixture, ProjectRecordFixture, ProjectRepo},
        Utc,
    };

    #[async_trait::async_trait]
    impl ListProjects for ProjectRepo {
        async fn list_projects(&self) -> FoundationResult<Vec<datastore::project::Project>> {
            let project_records = self
                .records
                .read()
                .await
                .values()
                .filter(|project| project.archived_at.is_none())
                .cloned()
                .collect();

            Ok(project_records)
        }
    }

    #[tokio::test]
    async fn it_returns_not_archived_projects() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());

        let repo = ProjectRepo::seed(vec![
            project_record.clone(),
            project_record_fixture(ProjectRecordFixture {
                name: Some("Food service".to_string()),
                slug: Some("food-service".to_string()),
                archived_at: Some(Utc::now()),
                ..Default::default()
            }),
        ]);

        let response = execute(&repo).await?;

        assert_eq!(response.projects, vec![project_record.into()]);

        Ok(())
    }
}
