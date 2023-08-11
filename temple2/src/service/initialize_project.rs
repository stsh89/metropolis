use crate::{
    datastore::{self, Repo},
    model::Project,
    AppResult,
};

pub struct InitializeProjectAttributes<'a> {
    pub name: String,
    pub description: String,
    pub repo: &'a Repo,
}

pub async fn execute(attributes: InitializeProjectAttributes<'_>) -> AppResult<Project> {
    let InitializeProjectAttributes {
        name,
        description,
        repo,
    } = attributes;

    let project = datastore::project::create(
        repo,
        datastore::project::CreateProjectAttributes { name, description },
    )
    .await?;

    Ok(project)
}
