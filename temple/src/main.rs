mod config;
mod datastore;
mod model;
mod result;
mod server;
mod service;
mod util;

pub use result::{AppError, AppResult};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let config = config::read_from_file("./config.json")?;
    let server_socket_address = config.server_socket_address()?;
    let projects = server::Projects::default();

    println!("Running server::proto::projects_server::ProjectsServer with tonic::transport::Server using http://{server_socket_address}");

    tonic::transport::Server::builder()
        .add_service(server::proto::projects_server::ProjectsServer::new(
            projects,
        ))
        .serve(server_socket_address)
        .await?;

    Ok(())
}
