use crate::{datastore, model::Project};
use uuid::Uuid;

pub struct RenameProjectError {}

pub struct RenameProjectAttributes {
    pub id: Uuid,
    pub new_name: String,
}

pub async fn execute(attributes: RenameProjectAttributes) -> Result<Project, RenameProjectError> {
    let RenameProjectAttributes { id, new_name } = attributes;

    let project = datastore::project::get(datastore::project::GetProjectAttributes { id })
        .await
        .map_err(|_err| RenameProjectError {})?;

    let updated_project = datastore::project::update(Project {
        slug: sluggify::sluggify::sluggify(&new_name, None),
        name: new_name,
        ..project
    })
    .await
    .map_err(|_err| RenameProjectError {})?;

    Ok(updated_project)
}
