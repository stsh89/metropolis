use super::{rpc, to_proto_model, ProjectsServer};
use crate::{
    repo::{ModelsRepo, ProjectsRepo},
    PortalError,
};
use foundation::{
    datastore,
    model::{CreateModelRecord, Model},
    project::GetProjectRecord,
    FoundationResult,
};
use tonic::{Request, Response, Status};

pub async fn execute(
    server: &ProjectsServer,
    request: Request<rpc::CreateModelRequest>,
) -> Result<Response<rpc::CreateModelResponse>, Status> {
    let rpc::CreateModelRequest {
        project_slug,
        description,
        name,
    } = request.into_inner();

    let repo = Repo {
        projects_repo: &server.projects_repo,
        models_repo: &server.models_repo,
    };

    let model = foundation::model::create::execute(
        &repo,
        foundation::model::create::Request {
            project_slug,
            description,
            name,
        },
    )
    .await
    .map_err(Into::<PortalError>::into)?
    .model;

    Ok(Response::new(rpc::CreateModelResponse {
        model: Some(to_proto_model(model)),
    }))
}

struct Repo<'a> {
    projects_repo: &'a ProjectsRepo,
    models_repo: &'a ModelsRepo,
}

#[async_trait::async_trait]
impl<'a> GetProjectRecord for Repo<'a> {
    async fn get_project_record(
        &self,
        slug: &str,
    ) -> FoundationResult<datastore::project::Project> {
        self.projects_repo
            .get_project_record(slug)
            .await
            .map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl<'a> CreateModelRecord for Repo<'a> {
    async fn create_model_record(
        &self,
        project_record: datastore::project::Project,
        model: Model,
    ) -> FoundationResult<datastore::model::Model> {
        self.models_repo
            .create_model_record(project_record, model)
            .await
            .map_err(Into::into)
    }
}
