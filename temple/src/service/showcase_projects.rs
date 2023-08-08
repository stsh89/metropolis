use crate::datastore::Repo;
use crate::{datastore, model::Project, AppResult};

pub struct ShowcaseProjectsAttributes<'a> {
    pub repo: &'a Repo,
}

pub async fn execute(attributes: ShowcaseProjectsAttributes<'_>) -> AppResult<Vec<Project>> {
    let ShowcaseProjectsAttributes { repo } = attributes;

    let projects = datastore::project::list(repo).await?;

    Ok(projects)
}
