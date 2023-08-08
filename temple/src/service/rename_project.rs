use crate::{datastore, model::Project, util, AppResult};
use uuid::Uuid;

pub struct RenameProjectAttributes {
    pub id: Uuid,
    pub name: String,
}

pub async fn execute(attributes: RenameProjectAttributes) -> AppResult<Project> {
    let RenameProjectAttributes { id, name } = attributes;

    let project = datastore::project::get(id).await?;

    let updated_project = datastore::project::update(Project {
        slug: util::slug::sluggify(&name),
        name,
        ..project
    })
    .await?;

    Ok(updated_project)
}
