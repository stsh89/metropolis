use serde::Deserialize;
use std::{
    error::Error,
    fmt::Display,
    net::{AddrParseError, SocketAddr},
};

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

#[derive(Debug)]
pub enum ConfigError {
    Deserialization(String),
    FileRead(String),
    InvalidParameter(String),
}

impl ConfigError {
    fn description(&self) -> &str {
        use ConfigError::*;

        match self {
            Deserialization(description) => description,
            InvalidParameter(description) => description,
            FileRead(description) => description,
        }
    }
}

impl Display for ConfigError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.description())
    }
}

impl Error for ConfigError {}

impl Config {
    pub fn server_socket_address(&self) -> Result<SocketAddr, ConfigError> {
        use ConfigError::*;

        let Some(temple_config) = self.temple.clone() else {
            return Err(InvalidParameter("missing or empty field 'temple'".to_string()))
        };

        let Some(server_config) = temple_config.server.clone() else {
            return Err(InvalidParameter("missing or empty field 'temple#server'".to_string()))
        };

        server_config.socket_address()
    }
}

impl ServerConfig {
    fn address(&self) -> Result<String, ConfigError> {
        use ConfigError::*;

        match &self.address {
            Some(address) => Ok(address.to_owned()),
            None => Err(InvalidParameter(Self::validation_error_text(
                "address",
                "missing or empty",
            ))),
        }
    }

    fn port(&self) -> Result<String, ConfigError> {
        use ConfigError::*;

        match &self.port {
            Some(port) => Ok(port.to_owned()),
            None => Err(InvalidParameter(Self::validation_error_text(
                "port",
                "missing or empty",
            ))),
        }
    }

    fn socket_address(&self) -> Result<SocketAddr, ConfigError> {
        use ConfigError::*;

        let socket_address_string = format!("{}:{}", self.address()?, self.port()?);
        let result: Result<SocketAddr, AddrParseError> = socket_address_string.parse();

        match result {
            Ok(socket_address) => Ok(socket_address),
            Err(error) => Err(InvalidParameter(error.to_string())),
        }
    }

    fn validation_error_text(field: &str, description: &str) -> String {
        format!("server#{} is {}", field, description)
    }
}

pub fn read_from_file(file_path: &str) -> Result<Config, ConfigError> {
    let serialized_config = match std::fs::read_to_string(file_path) {
        Ok(serialized_config) => serialized_config,
        Err(error) => {
            let error_text = format!("{}: {}", file_path, error);
            return Err(ConfigError::FileRead(error_text));
        }
    };

    deserialize_from_json(&serialized_config)
}

fn deserialize_from_json(serialized_config: &str) -> Result<Config, ConfigError> {
    serde_json::from_str(serialized_config)
        .map_err(|error| ConfigError::Deserialization(error.to_string()))
}
