use crate::{
    datastore::{self, Repo},
    model::{Project, Uuid},
    util, AppResult,
};

pub struct ListProjectsAttributes {
    pub archived: bool,
}

pub async fn list(repo: &Repo, attributes: ListProjectsAttributes) -> AppResult<Vec<Project>> {
    let ListProjectsAttributes { archived } = attributes;

    let projects = repo
        .select_projects(datastore::repo::SelectProjectsAttributes { archived })
        .await?;

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
            archivation_time: Default::default(),
            create_time: Default::default(),
            description,
            id: Default::default(),
            slug: util::slug::sluggify(&name),
            name,
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

pub async fn delete(repo: &Repo, project: Project) -> AppResult<()> {
    repo.delete_project(project).await
}
