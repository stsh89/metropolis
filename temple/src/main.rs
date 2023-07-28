mod server;

use server::{Projects, projects::projects_service_server::ProjectsServiceServer};
use tonic::transport::Server;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::1]:50051".parse()?;
    let projects = Projects::default();

    Server::builder()
        .add_service(ProjectsServiceServer::new(projects))
        .serve(addr)
        .await?;

    Ok(())
}
