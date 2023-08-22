use crate::{
    model::{DeleteModelAttributeRecord, GetModelAttributeRecord},
    FoundationResult,
};

pub struct Request {
    pub project_slug: String,
    pub model_slug: String,
    pub model_attribute_name: String,
}

pub async fn execute(
    repo: &(impl GetModelAttributeRecord + DeleteModelAttributeRecord),
    request: Request,
) -> FoundationResult<()> {
    let Request {
        project_slug,
        model_slug,
        model_attribute_name,
    } = request;

    let model_attribute_record = repo
        .get_model_attribute_record(&project_slug, &model_slug, &model_attribute_name)
        .await?;

    repo.delete_model_attribute_record(model_attribute_record)
        .await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::tests::Repo,
        tests::{
            model_attribute_record_fixture, model_record_fixture, project_record_fixture,
            ModelAttributeRecordFixture, ModelAttributeRepo, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[tokio::test]
    async fn it_deletes_a_model_attribute() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            ..Default::default()
        });
        let model_attribute_record = model_attribute_record_fixture(ModelAttributeRecordFixture {
            model_id: Some(model_record.id),
            ..Default::default()
        });

        let project_repo = ProjectRepo::seed(vec![project_record.clone()]);
        let model_repo = ModelRepo::seed(vec![model_record.clone()]);
        let model_attribute_repo = ModelAttributeRepo::seed(vec![model_attribute_record.clone()]);

        let repo = Repo {
            project_repo,
            model_repo,
            model_attribute_repo,
            ..Default::default()
        };

        execute(
            &repo,
            Request {
                project_slug: project_record.slug,
                model_slug: model_record.slug,
                model_attribute_name: "Title".to_string(),
            },
        )
        .await?;

        assert!(repo.model_attribute_repo.records().await.is_empty());

        Ok(())
    }
}
