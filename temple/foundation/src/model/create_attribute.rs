use crate::{datastore, model::Attribute, util, FoundationResult};

#[async_trait::async_trait]
pub trait CreateModelAttribute {
    async fn get_model(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::Model>;

    async fn create_model_attribute(
        &self,
        model: datastore::model::Model,
        attribute: Attribute,
    ) -> FoundationResult<datastore::model::Attribute>;
}

pub struct Request {
    pub project_slug: String,
    pub model_slug: String,
    pub description: String,
    pub name: String,
    pub kind: String,
}

pub struct Response {
    pub model_attribute: Attribute,
}

pub async fn execute(
    repo: &impl CreateModelAttribute,
    request: Request,
) -> FoundationResult<Response> {
    let Request {
        project_slug,
        model_slug,
        description,
        kind,
        name,
    } = request;

    let model_record = repo.get_model(&project_slug, &model_slug).await?;

    let model_attribute_record = repo
        .create_model_attribute(
            model_record,
            Attribute {
                description: util::string::optional(&description),
                kind: kind.parse()?,
                name,
            },
        )
        .await?;

    let response = Response {
        model_attribute: model_attribute_record.into(),
    };

    Ok(response)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        model::{tests::Repo, AttributeKind},
        tests::{
            model_record_fixture, project_record_fixture, ModelRecordFixture, ModelRepo,
            ProjectRepo,
        },
    };

    #[async_trait::async_trait]
    impl CreateModelAttribute for Repo {
        async fn get_model(
            &self,
            project_slug: &str,
            model_slug: &str,
        ) -> FoundationResult<datastore::model::Model> {
            let project_record = self.project_repo.find_by_slug(project_slug).await?;

            self.model_repo
                .find_by_slug(project_record.id, model_slug)
                .await
        }

        async fn create_model_attribute(
            &self,
            model_record: datastore::model::Model,
            attribute: Attribute,
        ) -> FoundationResult<datastore::model::Attribute> {
            let Attribute {
                description,
                name,
                kind,
            } = attribute;

            let mut model_attribute_records = self.model_attribute_repo.records.write().await;

            let model_attribute_record = datastore::model::Attribute {
                model_id: model_record.id,
                description: description.unwrap_or_default(),
                name,
                kind: kind.into(),
                ..Default::default()
            };

            model_attribute_records
                .insert(model_attribute_record.id, model_attribute_record.clone());

            Ok(model_attribute_record)
        }
    }

    #[tokio::test]
    async fn it_creates_a_model_attribute() -> FoundationResult<()> {
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

        let response = execute(
            &repo,
            Request {
                project_slug: project_record.slug,
                model_slug: model_record.slug,
                description: "The Title of the Book".to_string(),
                name: "Title".to_string(),
                kind: "string".to_string(),
            },
        )
        .await?;

        assert_eq!(
            repo.model_attribute_repo
                .records()
                .await
                .into_iter()
                .map(Into::<Attribute>::into)
                .collect::<Vec<Attribute>>(),
            vec![response.model_attribute.clone()]
        );

        assert_eq!(
            response.model_attribute,
            Attribute {
                description: Some("The Title of the Book".to_string()),
                kind: AttributeKind::String,
                name: "Title".to_string(),
            }
        );

        let model_attribute_record = repo
            .model_attribute_repo
            .find_by_name(model_record.id, "Title")
            .await?;

        assert_eq!(model_record.id, model_attribute_record.model_id);

        Ok(())
    }
}
