use crate::{
    datastore::{self, Repo},
    model::Project,
    AppResult,
};

pub struct ShowcaseProjectsAttributes<'a> {
    pub repo: &'a Repo,
}

pub async fn execute(attributes: ShowcaseProjectsAttributes<'_>) -> AppResult<Vec<Project>> {
    let ShowcaseProjectsAttributes { repo } = attributes;

    let projects = datastore::project::list(
        repo,
        datastore::project::ListProjectsAttributes { archived: false },
    )
    .await?;

    Ok(projects)
}
