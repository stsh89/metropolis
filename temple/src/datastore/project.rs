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

pub struct CreateProjectAttributes {
    pub name: String,
    pub description: String,
}

pub struct ProjectCreateError {
    pub description: String,
}

pub async fn create(attributes: CreateProjectAttributes) -> Result<Project, ProjectCreateError> {
    let datastore_client = DatastoreClient {};

    let CreateProjectAttributes { name, description } = attributes;

    let project = datastore_client
        .create_project(Project {
            id: Default::default(),
            create_time: Default::default(),
            name,
            description,
        })
        .await
        .map_err(|err| ProjectCreateError {
            description: err.description().to_owned(),
        })?;

    Ok(project)
}
