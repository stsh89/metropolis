use crate::{datastore, model::Project};
use uuid::Uuid;

pub struct RenameProjectError {}

pub struct RenameProjectAttributes {
    pub id: Uuid,
    pub name: String,
}

pub async fn execute(attributes: RenameProjectAttributes) -> Result<Project, RenameProjectError> {
    let RenameProjectAttributes { id, name } = attributes;

    let project = datastore::project::get(datastore::project::GetProjectAttributes { id })
        .await
        .map_err(|_err| RenameProjectError {})?;

    let updated_project = datastore::project::update(Project {
        slug: sluggify::sluggify::sluggify(&name, None),
        name,
        ..project
    })
    .await
    .map_err(|_err| RenameProjectError {})?;

    Ok(updated_project)
}
