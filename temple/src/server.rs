use tonic::{Request, Response, Status};

use projects::projects_service_server::{ProjectsService};
use projects::{ListProjectsResponse, ListProjectsRequest, Project};

pub mod projects {
    tonic::include_proto!("projects"); // The string specified here must match the proto package name
}


#[derive(Debug, Default)]
pub struct Projects {}

#[tonic::async_trait]
impl ProjectsService for Projects {
    async fn list_projects(
        &self,
        request: Request<ListProjectsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<ListProjectsResponse>, Status> { // Return an instance of type HelloReply
        println!("Got a request: {:?}", request);

        let response = projects::ListProjectsResponse {
            projects: vec![
                Project {
                    id: "bdabace9-d878-44c0-a846-19a729b41a67".to_string(),
                    name: "Metropolis".to_string(),
                    description: "Highly specialized Architecture Design and Documentation Tool.".to_string(),
                    create_timestamp: Some(prost_types::Timestamp {
                        seconds: 1690539573,
                        nanos: 0
                    })
                },
                Project {
                    id: "8d7618ef-2c6b-45b5-9e7e-3d0ef12c661a".to_string(),
                    name: "Diesel".to_string(),
                    description: "Safe, Extensible ORM and Query Builder for Rust.".to_string(),
                    create_timestamp: Some(prost_types::Timestamp {
                        seconds: 1690539373,
                        nanos: 0
                    })
                },
                Project {
                    id: "6d28578a-1ba0-43d1-a953-0bb1d855a0e1".to_string(),
                    name: "Livebook".to_string(),
                    description: "Livebook is a web application for writing interactive and collaborative code notebooks.".to_string(),
                    create_timestamp: Some(prost_types::Timestamp {
                        seconds: 1690539173,
                        nanos: 0
                    })
                }
            ],
        };

        Ok(Response::new(response)) // Send back our formatted greeting
    }
}
