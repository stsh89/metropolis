use crate::{AppError, AppResult};
use serde::Deserialize;

#[derive(Clone, Deserialize)]
pub struct AppConfiguration {
    pub server: Option<AppServerConfiguration>,
}

#[derive(Clone, Deserialize)]
pub struct AppServerConfiguration {
    pub address: Option<String>,
    pub port: Option<String>,
}

impl AppConfiguration {
    pub fn server_socket_address(&self) -> AppResult<std::net::SocketAddr> {
        let Some(server_config) = self.server.clone() else {
            return Err(AppError::invalid_argument("missin g AppConfiguration#server".to_string()))
        };

        server_config.socket_address()
    }
}

impl AppServerConfiguration {
    fn address(&self) -> AppResult<&str> {
        self.address.as_deref().ok_or(AppError::invalid_argument(
            "missing AppConfiguration#server#address",
        ))
    }

    fn port(&self) -> AppResult<&str> {
        self.port.as_deref().ok_or(AppError::invalid_argument(
            "missing AppConfiguration#server#port",
        ))
    }

    fn socket_address(&self) -> AppResult<std::net::SocketAddr> {
        let socket_address_string = format!("{}:{}", self.address()?, self.port()?);

        socket_address_string.parse().map_err(|err| {
            let mut error = AppError::invalid_argument(
                "invalid AppConfiguration#server#address or AppConfiguration#server#port",
            );
            error.set_source(std::sync::Arc::new(err));
            error
        })
    }
}
