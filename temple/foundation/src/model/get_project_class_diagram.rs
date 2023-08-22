use crate::{
    diagram,
    model::{ListModelOverviewRecords, ModelOverview},
    FoundationResult,
};

pub struct Request {
    pub project_slug: String,
}

pub struct Response {
    pub diagram: String,
}

pub async fn execute(
    repo: &impl ListModelOverviewRecords,
    request: Request,
) -> FoundationResult<Response> {
    let Request { project_slug } = request;

    let model_overviews: Vec<ModelOverview> = repo
        .list_model_overview_records(&project_slug)
        .await?
        .into_iter()
        .map(|model_overview_record| ModelOverview {
            model: model_overview_record.model.into(),
            associations: model_overview_record
                .associations
                .into_iter()
                .map(Into::into)
                .collect(),
            attributes: model_overview_record
                .attributes
                .into_iter()
                .map(Into::into)
                .collect(),
        })
        .collect();

    let diagram_model_classes = model_overviews
        .iter()
        .map(|model_overview| diagram::ModelClass {
            model: &model_overview.model,
            associations: model_overview.associations.as_slice(),
            attributes: model_overview.attributes.as_slice(),
        })
        .collect();

    let diagram = diagram::project_class_diagram(diagram_model_classes);

    let response = Response { diagram };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::tests::Repo,
        tests::{
            model_association_record_fixture, model_attribute_record_fixture, model_record_fixture,
            project_record_fixture, ModelAssociationRecordFixture, ModelAssociationRepo,
            ModelAttributeRecordFixture, ModelAttributeRepo, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[tokio::test]
    async fn it_returns_project_class_diagram() -> FoundationResult<()> {
        let project_record = project_record_fixture(Default::default());
        let model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            ..Default::default()
        });
        let model_attribute_record = model_attribute_record_fixture(ModelAttributeRecordFixture {
            model_id: Some(model_record.id),
            ..Default::default()
        });
        let associated_model_record = model_record_fixture(ModelRecordFixture {
            project_id: Some(project_record.id),
            name: Some("Publisher".to_string()),
            slug: Some("publisher".to_string()),
            ..Default::default()
        });
        let associated_model_attribute_record =
            model_attribute_record_fixture(ModelAttributeRecordFixture {
                model_id: Some(associated_model_record.id),
                name: Some("Name".to_string()),
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
        let model_attribute_repo = ModelAttributeRepo::seed(vec![
            model_attribute_record.clone(),
            associated_model_attribute_record.clone(),
        ]);
        let model_association_repo =
            ModelAssociationRepo::seed(vec![model_association_record.clone()]);

        let repo = Repo {
            project_repo,
            model_repo,
            model_attribute_repo,
            model_association_repo,
        };

        let response = execute(
            &repo,
            Request {
                project_slug: project_record.slug.to_string(),
            },
        )
        .await?;

        assert_eq!(
            response.diagram,
            r#"classDiagram
    class Book {
        +String Title
    }
    class Publisher {
        +String Name
    }

    Book --> Publisher
"#
        );

        Ok(())
    }
}
