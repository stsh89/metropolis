use crate::{
    model::{DeleteModelRecord, GetModelRecord},
    FoundationResult,
};

pub struct Request {
    pub project_slug: String,
    pub model_slug: String,
}

pub async fn execute(
    repo: &(impl GetModelRecord + DeleteModelRecord),
    request: Request,
) -> FoundationResult<()> {
    let Request {
        project_slug,
        model_slug,
    } = request;

    let model_record = repo.get_model_record(&project_slug, &model_slug).await?;

    repo.delete_model_record(model_record).await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::tests::Repo,
        tests::{
            model_record_fixture, project_record_fixture, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[tokio::test]
    async fn it_deletes_a_model() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            ..Default::default()
        });

        let project_repo = ProjectRepo::seed(vec![project_record.clone()]);
        let model_repo = ModelRepo::seed(vec![model_record.clone()]);

        let repo = Repo {
            project_repo,
            model_repo,
            ..Default::default()
        };

        execute(
            &repo,
            Request {
                project_slug: project_record.slug,
                model_slug: model_record.slug,
            },
        )
        .await?;

        assert!(repo.model_repo.records().await.is_empty());

        Ok(())
    }
}
