use crate::{
    datastore::{self, Repo},
    model::{Project, Utc},
    AppError, AppResult,
};
use uuid::Uuid;

pub struct ArchiveProjectAttributes<'a> {
    pub id: Uuid,
    pub repo: &'a Repo,
}

pub async fn execute(attributes: ArchiveProjectAttributes<'_>) -> AppResult<Project> {
    let ArchiveProjectAttributes { id, repo } = attributes;

    let project = datastore::project::get(repo, id).await?;

    if project.is_archived() {
        return Err(AppError::failed_precondition("Project already archived"));
    }

    let updated_project = datastore::project::update(
        repo,
        Project {
            archivation_time: Some(Utc::now()),
            ..project
        },
    )
    .await?;

    Ok(updated_project)
}
