use crate::{model::Project, service, util};
use tonic::{Request, Response, Status};

pub mod proto {
    tonic::include_proto!("proto.temple.v1"); // The string specified here must match the proto package name
}

#[derive(Debug, Default)]
pub struct Projects {}

#[tonic::async_trait]
impl proto::projects_server::Projects for Projects {
    async fn showcase_projects(
        &self,
        request: Request<proto::ShowcaseProjectsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::ShowcaseProjectsResponse>, Status> {
        println!("Got a request: {:?}", request);

        let projects = service::showcase_projects()
            .await?
            .into_iter()
            .map(to_proto_project)
            .collect();

        Ok(Response::new(proto::ShowcaseProjectsResponse { projects }))
    }

    async fn initialize_project(
        &self,
        request: Request<proto::InitializeProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::InitializeProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::InitializeProjectRequest { name, description } = request.into_inner();

        let project =
            service::initialize_project(service::InitializeProjectAttributes { name, description })
                .await?;

        Ok(Response::new(proto::InitializeProjectResponse {
            project: Some(to_proto_project(project)),
        }))
    }

    async fn rename_project(
        &self,
        request: Request<proto::RenameProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::RenameProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::RenameProjectRequest { id, name } = request.into_inner();

        let project = service::rename_project(service::RenameProjectAttributes {
            id: util::proto::uuid_from_proto_string(&id, "id")?,
            name,
        })
        .await?;

        Ok(Response::new(proto::RenameProjectResponse {
            project: Some(to_proto_project(project)),
        }))
    }

    async fn check_project_details(
        &self,
        request: Request<proto::CheckProjectDetailsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::CheckProjectDetailsResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::CheckProjectDetailsRequest { slug } = request.into_inner();

        let project =
            service::check_project_details(service::CheckProjectDetailsAttributes { slug }).await?;

        Ok(Response::new(proto::CheckProjectDetailsResponse {
            project: Some(to_proto_project(project)),
        }))
    }
}

fn to_proto_project(project: Project) -> proto::Project {
    proto::Project {
        create_time: Some(util::proto::to_proto_timestamp(project.create_time)),
        description: project.description,
        id: project.id.to_string(),
        name: project.name,
        slug: project.slug,
    }
}
