use serde::Deserialize;
use std::{
    error::Error,
    fmt::Display,
    net::{AddrParseError, SocketAddr},
};

#[derive(Deserialize)]
pub struct Config {
    pub temple_config: Option<TempleConfig>,
}

#[derive(Clone, Deserialize)]
pub struct TempleConfig {
    pub server_config: Option<ServerConfig>,
}

#[derive(Clone, Deserialize)]
pub struct ServerConfig {
    pub address: Option<String>,
    pub port: Option<String>,
}

#[derive(Debug)]
pub struct ConfigValidationError {
    pub field: String,
    pub description: String,
}

impl Display for ConfigValidationError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}: {}", self.field, self.description)
    }
}

#[derive(Debug)]
pub struct ConfigDeserializationError {
    pub description: String,
}

impl Display for ConfigDeserializationError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.description)
    }
}

impl Error for ConfigDeserializationError {}
impl Error for ConfigValidationError {}

impl Config {
    pub fn server_socket_address(&self) -> Result<SocketAddr, ConfigValidationError> {
        let Some(temple_config) = self.temple_config.clone() else {
            return Err(ConfigValidationError {
                field: "temple_config".to_string(),
                description: "missing".to_string(),
            })
        };

        let Some(server_config) = temple_config.server_config.clone() else {
            return Err(ConfigValidationError {
                field: "server_config".to_string(),
                description: "missing".to_string(),
            })
        };

        server_config.socket_address()
    }

    pub fn deserialize_from_json(serialized: &str) -> Result<Self, ConfigDeserializationError> {
        serde_json::from_str(&serialized).map_err(|error| ConfigDeserializationError {
            description: error.to_string(),
        })
    }
}

impl ServerConfig {
    fn socket_address(&self) -> Result<SocketAddr, ConfigValidationError> {
        let Some(address) = self.address.clone() else {
            return Err(ConfigValidationError {
                field: "server_config#address".to_string(),
                description: "missing".to_string(),
            });
        };

        let Some(port) = self.port.clone() else {
            return Err(ConfigValidationError {
                field: "server_config#port".to_string(),
                description: "missing".to_string(),
            });
        };

        let socket_address_string = format!("{}:{}", address, port);
        let result: Result<SocketAddr, AddrParseError> = socket_address_string.parse();

        match result {
            Ok(socket_address) => Ok(socket_address),
            Err(error) => Err(ConfigValidationError {
                field: "server_config".to_string(),
                description: error.to_string(),
            }),
        }
    }
}
