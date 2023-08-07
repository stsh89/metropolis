use uuid::Uuid;

use super::client::Client;
use crate::model::Project;

pub struct ProjectListError {
    pub description: String,
}

pub async fn list() -> Result<Vec<Project>, ProjectListError> {
    let datastore_client = Client {};

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
    let client = Client {};

    let CreateProjectAttributes { name, description } = attributes;

    let project = client
        .create_project(Project {
            id: Default::default(),
            create_time: Default::default(),
            slug: sluggify::sluggify::sluggify(&name, None),
            name,
            description,
        })
        .await
        .map_err(|err| ProjectCreateError {
            description: err.description().to_owned(),
        })?;

    Ok(project)
}

pub struct GetProjectAttributes {
    pub id: Uuid,
}

pub struct GetProjectError {
    pub description: String,
}

pub async fn get(attributes: GetProjectAttributes) -> Result<Project, GetProjectError> {
    let client = Client {};

    let GetProjectAttributes { id } = attributes;

    let project = client
        .get_project(id)
        .await
        .map_err(|err| GetProjectError {
            description: err.description().to_owned(),
        })?;

    Ok(project)
}

pub struct FindProjectError {
    pub description: String,
}

pub async fn find(slug: &str) -> Result<Project, FindProjectError> {
    let client = Client {};

    let project = client
        .find_project(slug)
        .await
        .map_err(|err| FindProjectError {
            description: err.description().to_owned(),
        })?;

    Ok(project)
}

pub struct UpdateProjectError {
    pub description: String,
}

pub async fn update(project: Project) -> Result<Project, UpdateProjectError> {
    let client = Client {};

    let project = client
        .update_project(project)
        .await
        .map_err(|err| UpdateProjectError {
            description: err.description().to_owned(),
        })?;

    Ok(project)
}
