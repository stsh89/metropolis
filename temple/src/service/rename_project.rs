use crate::{
    datastore::{self, Repo},
    model::Project,
    util, AppResult,
};
use uuid::Uuid;

pub struct RenameProjectAttributes<'a> {
    pub id: Uuid,
    pub name: String,
    pub repo: &'a Repo,
}

pub async fn execute(attributes: RenameProjectAttributes<'_>) -> AppResult<Project> {
    let RenameProjectAttributes { id, name, repo } = attributes;

    let project = datastore::project::get(repo, id).await?;

    let updated_project = datastore::project::update(
        repo,
        Project {
            slug: util::slug::sluggify(&name),
            name,
            ..project
        },
    )
    .await?;

    Ok(updated_project)
}
