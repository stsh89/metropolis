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
    let args = std::env::args().collect::<Vec<String>>();
    let config_file_path = &args[1];
    let config = config::read_from_file(config_file_path)?;

    let server_socket_address = config.app()?.server_socket_address()?;
    let projects = server::Projects {
        repo: std::sync::Arc::new(datastore::Repo {
            connection_string: config.datastore()?.connection_string()?,
        }),
    };

    println!("Running server::proto::projects_server::ProjectsServer with tonic::transport::Server using http://{server_socket_address}");

    tonic::transport::Server::builder()
        .add_service(server::proto::projects_server::ProjectsServer::new(
            projects,
        ))
        .serve(server_socket_address)
        .await?;

    Ok(())
}
