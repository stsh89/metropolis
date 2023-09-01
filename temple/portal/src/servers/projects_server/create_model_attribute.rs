use super::{rpc, to_proto_model_attribute, ProjectsServer};
use crate::{
    repo::{AttributeTypesRepo, ModelsRepo},
    PortalError,
};
use foundation::{
    attribute_type::{AttributeTypeRecord, GetAttributeTypeRecord},
    datastore,
    model::{self, Attribute, CreateModelAttributeRecord, GetModelRecord},
    FoundationResult,
};
use tonic::{Request, Response, Status};

pub async fn execute(
    server: &ProjectsServer,
    request: Request<rpc::CreateModelAttributeRequest>,
) -> Result<Response<rpc::CreateModelAttributeResponse>, Status> {
    let repo = Repo {
        attribute_types_repo: &server.attribute_types_repo,
        models_repo: &server.models_repo,
    };

    let rpc::CreateModelAttributeRequest {
        project_slug,
        model_slug,
        attribute_type_slug,
        description,
        name,
    } = request.into_inner();

    let model_attribute = model::create_attribute::execute(
        &repo,
        model::create_attribute::Request {
            project_slug,
            model_slug,
            description,
            attribute_type_slug,
            name,
        },
    )
    .await
    .map_err(Into::<PortalError>::into)?
    .model_attribute;

    Ok(Response::new(rpc::CreateModelAttributeResponse {
        model_attribute: Some(to_proto_model_attribute(model_attribute)),
    }))
}

struct Repo<'a> {
    attribute_types_repo: &'a AttributeTypesRepo,
    models_repo: &'a ModelsRepo,
}

#[async_trait::async_trait]
impl<'a> GetModelRecord for Repo<'a> {
    async fn get_model_record(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::Model> {
        self.models_repo
            .get_model_record(project_slug, model_slug)
            .await
    }
}

#[async_trait::async_trait]
impl<'a> GetAttributeTypeRecord for Repo<'a> {
    async fn get_attribute_type_record(
        &self,
        slug: &str,
    ) -> FoundationResult<Option<AttributeTypeRecord>> {
        self.attribute_types_repo
            .get_attribute_type_record(slug)
            .await
    }
}

#[async_trait::async_trait]
impl<'a> CreateModelAttributeRecord for Repo<'a> {
    async fn create_model_attribute_record(
        &self,
        model: datastore::model::Model,
        attribute_type_record: AttributeTypeRecord,
        attribute: Attribute,
    ) -> FoundationResult<datastore::model::Attribute> {
        self.models_repo
            .create_model_attribute_record(model, attribute_type_record, attribute)
            .await
    }
}
