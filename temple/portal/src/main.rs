mod config;
mod repo;
mod result;
mod servers;
mod util;

pub use result::{PortalError, PortalErrorCode, PortalResult};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = std::env::args().collect::<Vec<String>>();
    let config_file_path = &args[1];
    let configuration = config::read_from_file(config_file_path)?;

    let server_socket_address = configuration.server()?.socket_address()?;
    let projects_server = servers::projects_server::ProjectsServer {
        projects_repo: repo::ProjectsRepo {
            connection_string: configuration.database()?.connection_string()?,
        },
        models_repo: repo::ModelsRepo {
            connection_string: configuration.database()?.connection_string()?,
        },
        attribute_types_repo: repo::AttributeTypesRepo {
            connection_string: configuration.database()?.connection_string()?,
        },
    };
    let attribute_types_server = servers::attribute_types_server::AttributeTypesServer {
        attribute_types_repo: repo::AttributeTypesRepo {
            connection_string: configuration.database()?.connection_string()?,
        },
    };

    println!("Running server::proto::projects_server::ProjectsServer with tonic::transport::Server using http://{server_socket_address}");

    tonic::transport::Server::builder()
        .add_service(
            servers::projects_server::rpc::projects_server::ProjectsServer::new(projects_server),
        )
        .add_service(
            servers::attribute_types_server::rpc::attribute_types_server::AttributeTypesServer::new(
                attribute_types_server,
            ),
        )
        .serve(server_socket_address)
        .await?;

    Ok(())
}
