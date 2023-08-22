use crate::{
    model::{DeleteModelAssociationRecord, GetModelAssociationRecord},
    FoundationResult,
};

pub struct Request {
    pub project_slug: String,
    pub model_slug: String,
    pub model_association_name: String,
}

pub async fn execute(
    repo: &(impl GetModelAssociationRecord + DeleteModelAssociationRecord),
    request: Request,
) -> FoundationResult<()> {
    let Request {
        project_slug,
        model_slug,
        model_association_name,
    } = request;

    let model_association_record = repo
        .get_model_association_record(&project_slug, &model_slug, &model_association_name)
        .await?;

    repo.delete_model_association_record(model_association_record)
        .await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::tests::Repo,
        tests::{
            model_association_record_fixture, model_record_fixture, project_record_fixture,
            ModelAssociationRecordFixture, ModelAssociationRepo, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[tokio::test]
    async fn it_deletes_a_model_association() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            ..Default::default()
        });
        let associated_model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            name: Some("Publisher".to_string()),
            slug: Some("publisher".to_string()),
            ..Default::default()
        });
        let model_association_record =
            model_association_record_fixture(ModelAssociationRecordFixture {
                model_id: Some(model_record.id),
                associated_model: Some(associated_model_record.clone()),
                ..Default::default()
            });

        let project_repo = ProjectRepo::seed(vec![project_record.clone()]);
        let model_repo =
            ModelRepo::seed(vec![model_record.clone(), associated_model_record.clone()]);
        let model_association_repo =
            ModelAssociationRepo::seed(vec![model_association_record.clone()]);

        let repo = Repo {
            project_repo,
            model_repo,
            model_association_repo,
            ..Default::default()
        };

        execute(
            &repo,
            Request {
                project_slug: project_record.slug,
                model_slug: model_record.slug,
                model_association_name: "Publisher".to_string(),
            },
        )
        .await?;

        assert!(repo.model_association_repo.records().await.is_empty());

        Ok(())
    }
}
