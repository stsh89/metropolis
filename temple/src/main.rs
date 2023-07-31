mod config;
mod server;

use server::{projects::projects_service_server::ProjectsServiceServer, Projects};
use tonic::transport::Server;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let contents =
        std::fs::read_to_string("./local_config.json").expect("missing local_config.json file");

    let config = config::Config::deserialize_from_json(&contents)?;
    let server_socket_address = config.server_socket_address()?;
    let projects = Projects::default();

    println!("Server starting at {server_socket_address}");

    Server::builder()
        .add_service(ProjectsServiceServer::new(projects))
        .serve(server_socket_address)
        .await?;

    Ok(())
}
