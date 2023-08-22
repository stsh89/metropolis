use crate::{
    project::{DeleteProjectRecord, GetProjectRecord},
    FoundationResult,
};

pub struct Request {
    pub slug: String,
}

pub async fn execute(
    repo: &(impl GetProjectRecord + DeleteProjectRecord),
    request: Request,
) -> FoundationResult<()> {
    let Request { slug } = request;

    let project_record = repo.get_project_record(&slug).await?;

    repo.delete_project_record(project_record).await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::tests::{project_record_fixture, ProjectRepo};

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
