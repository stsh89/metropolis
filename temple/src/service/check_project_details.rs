use crate::{datastore, model::Project};

pub struct CheckProjectDetailsError {}

pub struct CheckProjectDetailsAttributes {
    pub slug: String,
}

pub async fn execute(attributes: CheckProjectDetailsAttributes) -> Result<Project, CheckProjectDetailsError> {
    let CheckProjectDetailsAttributes { slug } = attributes;

    let project = datastore::project::find(&slug)
        .await
        .map_err(|_err| CheckProjectDetailsError {})?;

    Ok(project)
}
