use crate::{
    datastore::{self, Repo},
    model::Project,
    AppResult,
};

pub struct InquireArchivedProjectsAttributes<'a> {
    pub repo: &'a Repo,
}

pub async fn execute(attributes: InquireArchivedProjectsAttributes<'_>) -> AppResult<Vec<Project>> {
    let InquireArchivedProjectsAttributes { repo } = attributes;

    let projects = datastore::project::list(
        repo,
        datastore::project::ListProjectsAttributes { archived: true },
    )
    .await?;

    Ok(projects)
}
