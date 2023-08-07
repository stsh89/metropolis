use crate::{datastore, model::Project};

pub struct ShowcaseProjectsError {}

pub async fn execute() -> Result<Vec<Project>, ShowcaseProjectsError> {
    let projects = datastore::project::list()
        .await
        .map_err(|_err| ShowcaseProjectsError {})?;

    Ok(projects)
}
