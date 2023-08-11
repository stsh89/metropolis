use crate::{
    datastore::{self, Repo},
    model::{Project, Uuid},
    AppError, AppResult,
};

pub struct RecoverProjectAttributes<'a> {
    pub id: Uuid,
    pub repo: &'a Repo,
}

pub async fn execute(attributes: RecoverProjectAttributes<'_>) -> AppResult<Project> {
    let RecoverProjectAttributes { id, repo } = attributes;

    let project = datastore::project::get(repo, id).await?;

    if !project.is_archived() {
        return Err(AppError::failed_precondition("Project is not archived"));
    }

    let updated_project = datastore::project::update(
        repo,
        Project {
            archivation_time: None,
            ..project
        },
    )
    .await?;

    Ok(updated_project)
}
