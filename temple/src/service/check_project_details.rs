use crate::{datastore, model::Project, AppResult};

pub struct CheckProjectDetailsAttributes {
    pub slug: String,
}

pub async fn execute(attributes: CheckProjectDetailsAttributes) -> AppResult<Project> {
    let CheckProjectDetailsAttributes { slug } = attributes;

    let project = datastore::project::find(&slug).await?;

    Ok(project)
}
