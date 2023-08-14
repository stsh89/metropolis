use crate::{PortalError, PortalResult};
use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
pub struct DatabaseConfig {
    pub ip_address: Option<String>,
    pub port: Option<String>,
}

impl DatabaseConfig {
    pub fn connection_string(&self) -> PortalResult<String> {
        Ok(format!("http://{}:{}", self.ip_address()?, self.port()?))
    }

    pub fn ip_address(&self) -> PortalResult<&str> {
        self.ip_address
            .as_deref()
            .ok_or(PortalError::invalid_argument("DatabaseConfig#ip_address"))
    }

    pub fn port(&self) -> PortalResult<&str> {
        self.port
            .as_deref()
            .ok_or(PortalError::invalid_argument("DatabaseConfig#port"))
    }
}
