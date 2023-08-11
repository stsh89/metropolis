use crate::{
    datastore::{self, Repo},
    AppError, AppResult,
};
use uuid::Uuid;

pub struct DeleteProjectAttributes<'a> {
    pub id: Uuid,
    pub repo: &'a Repo,
}

pub async fn execute(attributes: DeleteProjectAttributes<'_>) -> AppResult<()> {
    let DeleteProjectAttributes { id, repo } = attributes;

    let project = datastore::project::get(repo, id).await?;

    if !project.is_archived() {
        return Err(AppError::failed_precondition("Project is not archived"));
    }

    datastore::project::delete(repo, project).await?;

    Ok(())
}
