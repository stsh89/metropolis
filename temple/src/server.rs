use crate::datastore;
use crate::model::{Project, UtcDateTime};
use tonic::{Request, Response, Status};

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

        let projects = datastore::project::list()
            .await
            .map_err(|err| Status::internal(err.description))?
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

        let project = datastore::project::create(datastore::project::CreateProjectAttributes {
            name,
            description,
        })
        .await
        .map_err(|err| Status::internal(err.description))?;

        Ok(Response::new(proto::SetupProjectEnvironmentResponse {
            project: Some(to_proto_project(project)),
        }))
    }
}

fn to_proto_project(project: Project) -> proto::Project {
    proto::Project {
        id: project.id.to_string(),
        name: project.name,
        description: project.description,
        create_time: Some(to_proto_timestamp(project.create_time)),
    }
}

pub fn to_proto_timestamp(datetime: UtcDateTime) -> prost_types::Timestamp {
    prost_types::Timestamp {
        seconds: datetime.timestamp(),
        nanos: datetime.timestamp_subsec_nanos() as i32,
    }
}
