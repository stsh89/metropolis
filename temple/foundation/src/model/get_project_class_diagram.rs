use crate::{datastore, diagram, model, FoundationResult};

#[async_trait::async_trait]
pub trait ListModels {
    async fn list_models(&self, project_slug: &str) -> FoundationResult<ListModelsResponse>;
}

pub struct ListModelsResponse {
    pub models: Vec<ModelData>,
}

pub struct ModelData {
    pub model: datastore::model::Model,
    pub associations: Vec<datastore::model::Association>,
    pub attributes: Vec<datastore::model::Attribute>,
}

pub struct Request {
    pub project_slug: String,
}

pub struct Response {
    pub diagram: String,
}

pub async fn execute(repo: &impl ListModels, request: Request) -> FoundationResult<Response> {
    let Request { project_slug } = request;

    let list_models_response = repo.list_models(&project_slug).await?;

    let asdf = list_models_response
        .models
        .into_iter()
        .map(|model_data| {
            let attributes: Vec<model::Attribute> =
                model_data.attributes.into_iter().map(Into::into).collect();

            let associations: Vec<model::Association> = model_data
                .associations
                .into_iter()
                .map(Into::into)
                .collect();

            (model_data.model.into(), attributes, associations)
        })
        .collect::<Vec<(model::Model, Vec<model::Attribute>, Vec<model::Association>)>>();

    let diagram_model_classes = asdf
        .iter()
        .map(|(model, attributes, associations)| diagram::ModelClass {
            model,
            attributes: attributes.as_slice(),
            associations: associations.as_slice(),
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

    #[async_trait::async_trait]
    impl ListModels for Repo {
        async fn list_models(&self, project_slug: &str) -> FoundationResult<ListModelsResponse> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            let mut model_records: Vec<datastore::model::Model> = self
                .model_repo
                .records()
                .await
                .into_iter()
                .filter(|model_record| model_record.project_id == project_record.id)
                .collect();

            model_records.sort_by(|a, b| a.name.cmp(&b.name));

            let mut models: Vec<ModelData> = Vec::with_capacity(model_records.len());

            for model_record in model_records {
                let associations = self.model_association_repo.list(model_record.id).await?;
                let attributes = self.model_attribute_repo.list(model_record.id).await?;

                models.push(ModelData {
                    model: model_record,
                    associations,
                    attributes,
                });
            }

            Ok(ListModelsResponse { models })
        }
    }

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
