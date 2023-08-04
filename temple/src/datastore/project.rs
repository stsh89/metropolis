use crate::{client::DatastoreClient, model::Project};

pub struct ProjectListError {
    pub description: String,
}

pub async fn list() -> Result<Vec<Project>, ProjectListError> {
    let datastore_client = DatastoreClient {};

    let projects = datastore_client
        .select_projects()
        .await
        .map_err(|err| ProjectListError {
            description: err.description().to_owned(),
        })?;

    Ok(projects)
}
