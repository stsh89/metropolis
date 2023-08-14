use crate::{PortalError, PortalResult};
use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
pub struct ServerConfig {
    pub ip_address: Option<String>,
    pub port: Option<String>,
}

impl ServerConfig {
    pub fn socket_address(&self) -> PortalResult<std::net::SocketAddr> {
        self.connection_string()?.parse().map_err(|err| {
            let mut error =
                PortalError::invalid_argument("ServerConfig#address or ServerConfig#port");
            error.set_source(std::sync::Arc::new(err));
            error
        })
    }

    pub fn ip_address(&self) -> PortalResult<&str> {
        self.ip_address
            .as_deref()
            .ok_or(PortalError::invalid_argument("ServerConfig#address"))
    }

    pub fn port(&self) -> PortalResult<&str> {
        self.port
            .as_deref()
            .ok_or(PortalError::invalid_argument("ServerConfig#port"))
    }

    fn connection_string(&self) -> PortalResult<String> {
        Ok(format!("{}:{}", self.ip_address()?, self.port()?))
    }
}
