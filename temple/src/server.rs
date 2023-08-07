use crate::{
    model::{Project, UtcDateTime},
    service,
};
use tonic::{Request, Response, Status};
use uuid::Uuid;

pub mod proto {
    tonic::include_proto!("proto.temple.v1"); // The string specified here must match the proto package name
}

#[derive(Debug, Default)]
pub struct Projects {}

#[tonic::async_trait]
impl proto::projects_server::Projects for Projects {
    async fn list_projects(
        &self,
        request: Request<proto::ListProjectsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::ListProjectsResponse>, Status> {
        println!("Got a request: {:?}", request);

        let projects = service::showcase_projects()
            .await
            .map_err(|_err| Status::internal(""))?
            .into_iter()
            .map(to_proto_project)
            .collect();

        Ok(Response::new(proto::ListProjectsResponse { projects }))
    }

    async fn setup_project_environment(
        &self,
        request: Request<proto::SetupProjectEnvironmentRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::SetupProjectEnvironmentResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::SetupProjectEnvironmentRequest { name, description } = request.into_inner();

        let project =
            service::setup_project_environment(service::SetupProjectEnvironmentAttributes {
                name,
                description,
            })
            .await
            .map_err(|_err| Status::internal(""))?;

        Ok(Response::new(proto::SetupProjectEnvironmentResponse {
            project: Some(to_proto_project(project)),
        }))
    }

    async fn rename_project(
        &self,
        request: Request<proto::RenameProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::RenameProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::RenameProjectRequest { id, new_name } = request.into_inner();

        let project = service::rename_project(service::RenameProjectAttributes {
            id: from_proto_id(&id)?,
            new_name,
        })
        .await
        .map_err(|_err| Status::internal(""))?;

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

        let project = service::check_project_details(service::CheckProjectDetailsAttributes {
            slug
        })
        .await
        .map_err(|_err| Status::internal(""))?;

        Ok(Response::new(proto::CheckProjectDetailsResponse {
            project: Some(to_proto_project(project)),
        }))
    }
}

fn to_proto_project(project: Project) -> proto::Project {
    proto::Project {
        create_time: Some(to_proto_timestamp(project.create_time)),
        description: project.description,
        id: project.id.to_string(),
        name: project.name,
        slug: project.slug,
    }
}

pub fn to_proto_timestamp(datetime: UtcDateTime) -> prost_types::Timestamp {
    prost_types::Timestamp {
        seconds: datetime.timestamp(),
        nanos: datetime.timestamp_subsec_nanos() as i32,
    }
}

fn from_proto_id(id: &str) -> Result<Uuid, Status> {
    Uuid::parse_str(id).map_err(|_err| Status::invalid_argument("id"))
}
