use crate::{
    datastore,
    project::Project,
    project::{GetProjectRecord, RenameProjectRecord},
    util, FoundationResult,
};

pub struct Request {
    pub slug: String,
    pub name: String,
}

pub struct Response {
    pub project: Project,
}

pub async fn execute(
    repo: &(impl GetProjectRecord + RenameProjectRecord),
    request: Request,
) -> FoundationResult<Response> {
    let Request { slug, name } = request;

    let project_record = repo.get_project_record(&slug).await?;

    let project_record = repo
        .rename_project_record(datastore::project::Project {
            slug: util::slug::sluggify(&name),
            name,
            ..project_record
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
    use crate::tests::{project_record_fixture, ProjectRepo};

    #[tokio::test]
    async fn it_changes_project_name_and_slug() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());

        let repo = ProjectRepo::seed(vec![project_record.clone()]);

        let response = execute(
            &repo,
            Request {
                slug: project_record.slug,
                name: "Food service".to_string(),
            },
        )
        .await?;

        assert_eq!(
            repo.records()
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
                name: "Food service".to_string(),
                slug: "food-service".to_string()
            }
        );

        Ok(())
    }
}
