use crate::{datastore, project::Project, util, FoundationResult};

#[async_trait::async_trait]
pub trait RenameProject {
    async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project>;

    async fn rename_project(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<datastore::project::Project>;
}

pub struct Request {
    pub slug: String,
    pub name: String,
}

pub struct Response {
    pub project: Project,
}

pub async fn execute(repo: &impl RenameProject, request: Request) -> FoundationResult<Response> {
    let Request { slug, name } = request;

    let project_record = repo.get_project(&slug).await?;

    let project_record = repo
        .rename_project(datastore::project::Project {
            slug: util::slug::sluggify(&name),
            name,
            ..project_record
        })
        .await?;

    let response = Response {
        project: project_record.into(),
    };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::project::tests::ProjectRepo;

    #[async_trait::async_trait]
    impl RenameProject for ProjectRepo {
        async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project> {
            self.find_project_by_slug(slug).await
        }

        async fn rename_project(
            &self,
            project_record: datastore::project::Project,
        ) -> FoundationResult<datastore::project::Project> {
            let mut found_project_record = self.get(project_record.id).await?;

            let mut project_records = self.projects.write().await;

            found_project_record.name = project_record.name;
            found_project_record.slug = project_record.slug;

            project_records.insert(found_project_record.id, found_project_record.clone());

            Ok(found_project_record)
        }
    }

    fn projec_records() -> Vec<datastore::project::Project> {
        vec![datastore::project::Project {
            name: "Book store".to_string(),
            slug: "book-store".to_string(),
            ..Default::default()
        }]
    }

    fn valid_request() -> Request {
        Request {
            slug: "book-store".to_string(),
            name: "Food service".to_string(),
        }
    }

    #[tokio::test]
    async fn it_changes_project_name_and_slug() -> FoundationResult<()> {
        let repo = ProjectRepo::initialize(projec_records());
        let response = execute(&repo, valid_request()).await?;

        assert_eq!(
            repo.projects()
                .await
                .into_iter()
                .map(Into::<Project>::into)
                .collect::<Vec<Project>>(),
            vec![response.project.clone()]
        );

        assert_eq!(
            response.project,
            Project {
                description: None,
                name: "Food service".to_string(),
                slug: "food-service".to_string()
            }
        );

        Ok(())
    }
}
