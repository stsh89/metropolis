mod app;
mod datastore;

use crate::{AppError, AppResult};
use serde::Deserialize;

#[derive(Deserialize)]
pub struct Configuration {
    pub temple: Option<app::AppConfiguration>,
    pub gymnasium: Option<datastore::DatastoreConfiguration>,
}

impl Configuration {
    pub fn app(&self) -> AppResult<app::AppConfiguration> {
        self.temple
            .clone()
            .ok_or(AppError::invalid_argument("missing Configuration#temple"))
    }

    pub fn datastore(&self) -> AppResult<datastore::DatastoreConfiguration> {
        self.gymnasium.clone().ok_or(AppError::invalid_argument(
            "missing Configuration#gymnasium",
        ))
    }
}

pub fn read_from_file(file_path: &str) -> AppResult<Configuration> {
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

fn deserialize_from_json(serialized_config: &str) -> AppResult<Configuration> {
    serde_json::from_str(serialized_config).map_err(|err| {
        let mut error = AppError::failed_precondition("Configuration json deserialization failed");
        error.set_source(std::sync::Arc::new(err));
        error
    })
}
