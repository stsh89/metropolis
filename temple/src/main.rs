mod config;
mod datastore;
mod model;
mod result;
mod server;
mod service;
mod util;

pub use result::{AppError, AppResult};

use server::proto;
use tonic::transport::Server;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let config = config::read_from_file("./config.json")?;
    let server_socket_address = config.server_socket_address()?;
    let projects = server::Projects::default();

    println!("Server starting at {server_socket_address}");

    Server::builder()
        .add_service(proto::projects_server::ProjectsServer::new(projects))
        .serve(server_socket_address)
        .await?;

    Ok(())
}
