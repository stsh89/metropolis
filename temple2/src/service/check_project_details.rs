use crate::{
    datastore::{self, Repo},
    model::Project,
    AppResult,
};

pub struct CheckProjectDetailsAttributes<'a> {
    pub slug: String,
    pub repo: &'a Repo,
}

pub async fn execute(attributes: CheckProjectDetailsAttributes<'_>) -> AppResult<Project> {
    let CheckProjectDetailsAttributes { slug, repo } = attributes;

    let project = datastore::project::find(repo, &slug).await?;

    Ok(project)
}
