use crate::{datastore, project::Project, util, FoundationResult};

#[async_trait::async_trait]
pub trait RenameProject {
    async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project>;

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

    let project_record = repo.get_project(slug).await?;

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
    use crate::tests::{project_record_fixture, ProjectRepo};

    #[async_trait::async_trait]
    impl RenameProject for ProjectRepo {
        async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project> {
            self.find_by_slug(&slug).await
        }

        async fn rename_project(
            &self,
            project_record: datastore::project::Project,
        ) -> FoundationResult<datastore::project::Project> {
            let mut found_project_record = self.get(project_record.id).await?;

            let mut project_records = self.records.write().await;

            found_project_record.name = project_record.name;
            found_project_record.slug = project_record.slug;

            project_records.insert(found_project_record.id, found_project_record.clone());

            Ok(found_project_record)
        }
    }

    #[tokio::test]
    async fn it_changes_project_name_and_slug() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());

        let repo = ProjectRepo::seed(vec![project_record.clone()]);

        let response = execute(
            &repo,
            Request {
                slug: project_record.slug,
                name: "Food service".to_string(),
            },
        )
        .await?;

        assert_eq!(
            repo.records()
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
