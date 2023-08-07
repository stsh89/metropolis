use crate::{datastore, model::Project};

pub struct InitializeProjectError {}

pub struct InitializeProjectAttributes {
    pub name: String,
    pub description: String,
}

pub async fn execute(
    attributes: InitializeProjectAttributes,
) -> Result<Project, InitializeProjectError> {
    let InitializeProjectAttributes { name, description } = attributes;

    let project = datastore::project::create(datastore::project::CreateProjectAttributes {
        name,
        description,
    })
    .await
    .map_err(|_err| InitializeProjectError {})?;

    Ok(project)
}
