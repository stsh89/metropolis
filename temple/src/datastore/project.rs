use super::client::Client;
use crate::{
    model::{Project, Uuid},
    util, AppResult,
};

pub async fn list() -> AppResult<Vec<Project>> {
    let projects = Client {}.select_projects().await?;

    Ok(projects)
}

pub struct CreateProjectAttributes {
    pub name: String,
    pub description: String,
}

pub async fn create(attributes: CreateProjectAttributes) -> AppResult<Project> {
    let client = Client {};

    let CreateProjectAttributes { name, description } = attributes;

    let project = client
        .create_project(Project {
            id: Default::default(),
            create_time: Default::default(),
            slug: util::slug::sluggify(&name),
            name,
            description,
        })
        .await?;

    Ok(project)
}

pub async fn get(id: Uuid) -> AppResult<Project> {
    let client = Client {};

    let project = client.get_project(id).await?;

    Ok(project)
}

pub async fn find(slug: &str) -> AppResult<Project> {
    let client = Client {};

    let project = client.find_project(slug).await?;

    Ok(project)
}

pub async fn update(project: Project) -> AppResult<Project> {
    let client = Client {};

    let project = client.update_project(project).await?;

    Ok(project)
}
