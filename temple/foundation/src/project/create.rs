use crate::{
    project::{CreateProjectRecord, Project},
    util, FoundationResult,
};

pub struct Request {
    pub name: String,
    pub description: String,
}

pub struct Response {
    pub project: Project,
}

pub async fn execute(
    repo: &impl CreateProjectRecord,
    request: Request,
) -> FoundationResult<Response> {
    let Request { name, description } = request;

    let project_record = repo
        .create_project_record(Project {
            slug: util::slug::sluggify(&name),
            name,
            description: util::string::optional(&description),
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
    use crate::tests::ProjectRepo;

    #[tokio::test]
    async fn it_creates_a_project() -> FoundationResult<()> {
        let repo = ProjectRepo::seed(vec![]);

        let response = execute(
            &repo,
            Request {
                name: "Book store".to_string(),
                description: "Buy and sell books platform".to_string(),
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
                description: Some("Buy and sell books platform".to_string()),
                name: "Book store".to_string(),
                slug: "book-store".to_string()
            }
        );

        Ok(())
    }
}
