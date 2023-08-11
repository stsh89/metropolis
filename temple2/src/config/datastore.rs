use crate::{AppError, AppResult};
use serde::Deserialize;

#[derive(Clone, Deserialize)]
pub struct DatastoreConfiguration {
    pub server: Option<DatastoreServerConfiguration>,
}

#[derive(Clone, Deserialize)]
pub struct DatastoreServerConfiguration {
    pub address: Option<String>,
    pub port: Option<String>,
}

impl DatastoreConfiguration {
    pub fn connection_string(&self) -> AppResult<String> {
        let Some(server_config) = self.server.clone() else {
            return Err(AppError::failed_precondition("DatastoreConfiguration#server is missing".to_string()))
        };

        server_config.connection_string()
    }
}

impl DatastoreServerConfiguration {
    fn connection_string(&self) -> AppResult<String> {
        Ok(format!("http://{}:{}", self.address()?, self.port()?))
    }

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
}
