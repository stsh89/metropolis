use crate::{AppError, AppResult};
use serde::Deserialize;

#[derive(Deserialize)]
pub struct Config {
    pub temple: Option<TempleConfig>,
}

#[derive(Clone, Deserialize)]
pub struct TempleConfig {
    pub server: Option<ServerConfig>,
}

#[derive(Clone, Deserialize)]
pub struct ServerConfig {
    pub address: Option<String>,
    pub port: Option<String>,
}

impl Config {
    pub fn server_socket_address(&self) -> AppResult<std::net::SocketAddr> {
        let Some(temple_config) = self.temple.clone() else {
            return Err(AppError::failed_precondition("missing or empty field 'temple'".to_string()))
        };

        let Some(server_config) = temple_config.server.clone() else {
            return Err(AppError::failed_precondition("missing or empty field 'temple#server'".to_string()))
        };

        server_config.socket_address()
    }
}

impl ServerConfig {
    fn address(&self) -> AppResult<&str> {
        self.address
            .as_deref()
            .ok_or(AppError::failed_precondition("server#address is missing"))
    }

    fn port(&self) -> AppResult<&str> {
        self.port
            .as_deref()
            .ok_or(AppError::failed_precondition("server#port is missing"))
    }

    fn socket_address(&self) -> AppResult<std::net::SocketAddr> {
        let socket_address_string = format!("{}:{}", self.address()?, self.port()?);

        socket_address_string.parse().map_err(|err| {
            let mut error = AppError::failed_precondition(format!(
                "invalid socket address: {socket_address_string}"
            ));
            error.set_source(std::sync::Arc::new(err));
            error
        })
    }
}

pub fn read_from_file(file_path: &str) -> AppResult<Config> {
    let serialized_config = match std::fs::read_to_string(file_path) {
        Ok(serialized_config) => serialized_config,
        Err(err) => {
            let mut error = AppError::failed_precondition(format!(
                "failed to read configuration file: #{file_path}"
            ));
            error.set_source(std::sync::Arc::new(err));
            return Err(error);
        }
    };

    deserialize_from_json(&serialized_config)
}

fn deserialize_from_json(serialized_config: &str) -> AppResult<Config> {
    serde_json::from_str(serialized_config).map_err(|err| {
        let mut error = AppError::failed_precondition("can't deserialize a Config");
        error.set_source(std::sync::Arc::new(err));
        error
    })
}
