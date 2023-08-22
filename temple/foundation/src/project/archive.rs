use crate::{
    project::{ArchiveProjectRecord, GetProjectRecord},
    FoundationResult,
};

pub struct Request {
    pub slug: String,
}

pub async fn execute(
    repo: &(impl GetProjectRecord + ArchiveProjectRecord),
    request: Request,
) -> FoundationResult<()> {
    let Request { slug } = request;

    let project_record = repo.get_project_record(&slug).await?;

    repo.archive_project_record(project_record).await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::tests::{project_record_fixture, ProjectRecordFixture, ProjectRepo};

    #[tokio::test]
    async fn it_marks_a_project_as_archived() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());

        let repo = ProjectRepo::seed(vec![
            project_record.clone(),
            project_record_fixture(ProjectRecordFixture {
                name: Some("Food service".to_string()),
                slug: Some("food-service".to_string()),
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
            .is_some(),);

        assert!(repo
            .find_by_slug("food-service")
            .await?
            .archived_at
            .is_none(),);

        Ok(())
    }
}
