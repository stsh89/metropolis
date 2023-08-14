mod database;
mod server;

use crate::{PortalError, PortalResult};
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct Config {
    pub server: Option<server::ServerConfig>,
    pub database: Option<database::DatabaseConfig>,
}

impl Config {
    pub fn server(&self) -> PortalResult<server::ServerConfig> {
        self.server
            .clone()
            .ok_or(PortalError::invalid_argument("Config#server"))
    }

    pub fn database(&self) -> PortalResult<database::DatabaseConfig> {
        self.database
            .clone()
            .ok_or(PortalError::invalid_argument("Config#database"))
    }
}

pub fn read_from_file(file_path: &str) -> PortalResult<Config> {
    let serialized_config = match std::fs::read_to_string(file_path) {
        Ok(serialized_config) => serialized_config,
        Err(err) => {
            let mut error =
                PortalError::internal(format!("failed to read configuration file: {file_path}"));
            error.set_source(std::sync::Arc::new(err));
            return Err(error);
        }
    };

    deserialize_from_json(&serialized_config)
}

fn deserialize_from_json(serialized_config: &str) -> PortalResult<Config> {
    serde_json::from_str(serialized_config).map_err(|err| {
        let mut error = PortalError::internal("Configuration json deserialization failed");
        error.set_source(std::sync::Arc::new(err));
        error
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_reads_config_from_json_file() -> PortalResult<()> {
        let config = read_from_file("config.json.sample")?;

        let server_config = config.server()?;
        assert_eq!(server_config.port()?, "50051");
        assert_eq!(server_config.ip_address()?, "[::1]");

        let database_config = config.database()?;
        assert_eq!(database_config.port()?, "50052");
        assert_eq!(database_config.ip_address()?, "localhost");

        Ok(())
    }
}
