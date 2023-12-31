use crate::{
    project::Project,
    project::{ListProjectRecordFilterArchive, ListProjectRecordFilters, ListProjectRecords},
    FoundationResult,
};

pub struct Response {
    pub projects: Vec<Project>,
}

pub async fn execute(repo: &impl ListProjectRecords) -> FoundationResult<Response> {
    let project_records = repo
        .list_project_records(ListProjectRecordFilters {
            archive_filter: ListProjectRecordFilterArchive::ArchivedOnly,
        })
        .await?;

    let response = Response {
        projects: project_records.into_iter().map(Into::into).collect(),
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

    #[tokio::test]
    async fn it_returns_not_archived_projects() -> FoundationResult<()> {
        let project_record = project_record_fixture(ProjectRecordFixture {
            name: Some("Food service".to_string()),
            slug: Some("food-service".to_string()),
            archived_at: Some(Utc::now()),
            ..Default::default()
        });

        let repo = ProjectRepo::seed(vec![
            project_record.clone(),
            project_record_fixture(Default::default()),
        ]);

        let response = execute(&repo).await?;

        assert_eq!(response.projects, vec![project_record.into()]);

        Ok(())
    }
}
