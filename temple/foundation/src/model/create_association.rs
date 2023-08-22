use crate::{
    model::{Association, CreateModelAssociationRecord, GetModelRecord},
    util, FoundationResult,
};

pub struct Request {
    pub project_slug: String,
    pub model_slug: String,
    pub associated_model_slug: String,
    pub description: String,
    pub name: String,
    pub kind: String,
}

pub struct Response {
    pub model_association: Association,
}

pub async fn execute(
    repo: &(impl GetModelRecord + CreateModelAssociationRecord),
    request: Request,
) -> FoundationResult<Response> {
    let Request {
        project_slug,
        model_slug,
        description,
        name,
        kind,
        associated_model_slug,
    } = request;

    let model_record = repo.get_model_record(&project_slug, &model_slug).await?;

    let associated_model_record = repo
        .get_model_record(&project_slug, &associated_model_slug)
        .await?;

    let association_record = repo
        .create_model_association_record(
            model_record,
            associated_model_record.clone(),
            Association {
                description: util::string::optional(&description),
                name,
                kind: kind.parse()?,
                model: associated_model_record.clone().into(),
            },
        )
        .await?;

    let response = Response {
        model_association: association_record.into(),
    };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::{tests::Repo, AssociationKind},
        tests::{
            model_record_fixture, project_record_fixture, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[tokio::test]
    async fn it_creates_a_model_association() -> FoundationResult<()> {
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

        let project_repo = ProjectRepo::seed(vec![project_record.clone()]);
        let model_repo =
            ModelRepo::seed(vec![model_record.clone(), associated_model_record.clone()]);

        let repo = Repo {
            project_repo,
            model_repo,
            ..Default::default()
        };

        let response = execute(
            &repo,
            Request {
                project_slug: project_record.slug,
                model_slug: model_record.slug.clone(),
                description: "Book should belong to some Publisher".to_string(),
                name: "Publisher".to_string(),
                kind: "belongs_to".to_string(),
                associated_model_slug: associated_model_record.slug.to_string(),
            },
        )
        .await?;

        assert_eq!(repo.model_association_repo.records().await.len(), 1);

        assert_eq!(
            response.model_association,
            Association {
                description: Some("Book should belong to some Publisher".to_string()),
                kind: AssociationKind::BelongsTo,
                name: "Publisher".to_string(),
                model: associated_model_record.clone().into(),
            }
        );

        let model_association_record = repo
            .model_association_repo
            .find_by_name(model_record.id, "Publisher")
            .await?;

        assert_eq!(model_record.id, model_association_record.model_id);
        assert_eq!(
            associated_model_record.id,
            model_association_record.associated_model.id
        );

        Ok(())
    }
}
