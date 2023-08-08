use crate::{datastore, model::Project, AppResult};

pub async fn execute() -> AppResult<Vec<Project>> {
    let projects = datastore::project::list().await?;

    Ok(projects)
}
