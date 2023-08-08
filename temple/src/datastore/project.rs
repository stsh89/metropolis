use crate::{
    datastore::Repo,
    model::{Project, Uuid},
    util, AppResult,
};

pub async fn list(repo: &Repo) -> AppResult<Vec<Project>> {
    let projects = repo.select_projects().await?;

    Ok(projects)
}

pub struct CreateProjectAttributes {
    pub name: String,
    pub description: String,
}

pub async fn create(repo: &Repo, attributes: CreateProjectAttributes) -> AppResult<Project> {
    let CreateProjectAttributes { name, description } = attributes;

    let project = repo
        .create_project(Project {
            id: Default::default(),
            create_time: Default::default(),
            slug: util::slug::sluggify(&name),
            name,
            description,
        })
        .await?;

    Ok(project)
}

pub async fn get(repo: &Repo, id: Uuid) -> AppResult<Project> {
    let project = repo.get_project(id).await?;

    Ok(project)
}

pub async fn find(repo: &Repo, slug: &str) -> AppResult<Project> {
    let project = repo.find_project(slug).await?;

    Ok(project)
}

pub async fn update(repo: &Repo, project: Project) -> AppResult<Project> {
    let project = repo.update_project(project).await?;

    Ok(project)
}
