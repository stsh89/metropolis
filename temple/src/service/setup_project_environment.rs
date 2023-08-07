use crate::{datastore, model::Project};

pub struct SetupProjectEnvironmentError {}

pub struct SetupProjectEnvironmentAttributes {
    pub name: String,
    pub description: String,
}

pub async fn execute(
    attributes: SetupProjectEnvironmentAttributes,
) -> Result<Project, SetupProjectEnvironmentError> {
    let SetupProjectEnvironmentAttributes { name, description } = attributes;

    let project = datastore::project::create(datastore::project::CreateProjectAttributes {
        name,
        description,
    })
    .await
    .map_err(|_err| SetupProjectEnvironmentError {})?;

    Ok(project)
}
