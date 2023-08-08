use crate::{datastore, model::Project, AppResult};

pub struct InitializeProjectAttributes {
    pub name: String,
    pub description: String,
}

pub async fn execute(attributes: InitializeProjectAttributes) -> AppResult<Project> {
    let InitializeProjectAttributes { name, description } = attributes;

    let project = datastore::project::create(datastore::project::CreateProjectAttributes {
        name,
        description,
    })
    .await?;

    Ok(project)
}
