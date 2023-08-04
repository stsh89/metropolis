use crate::model::{Project, UtcDateTime};
use chrono::TimeZone;
use uuid::Uuid;

pub mod proto {
    tonic::include_proto!("proto.gymnasium.v1");

    pub mod dimensions {
        tonic::include_proto!("proto.gymnasium.v1.dimensions");
    }
}

pub struct Client {}

#[derive(Debug)]
pub enum ClientError {
    ConnectionError(String),
    EndpointRequestError(String),
    DataConversionError(String),
}

impl ClientError {
    pub fn description(&self) -> &str {
        match self {
            ClientError::ConnectionError(description) => description,
            ClientError::EndpointRequestError(description) => description,
            ClientError::DataConversionError(description) => description,
        }
    }
}

impl Client {
    pub async fn select_projects(&self) -> Result<Vec<Project>, ClientError> {
        use ClientError::*;

        let mut client =
            proto::dimensions_client::DimensionsClient::connect("http://localhost:50052")
                .await
                .map_err(|err| ConnectionError(err.to_string()))?;

        let response = client
            .select_dimension_records(proto::SelectDimensionRecordsRequest {
                parameters: Some(
                    proto::select_dimension_records_request::Parameters::ProjectParameters(
                        proto::ProjectParameters {},
                    ),
                ),
            })
            .await
            .map_err(|err| EndpointRequestError(err.to_string()))?
            .into_inner();

        if response.records.is_none() {
            return Err(EndpointRequestError(
                "missing required field: #records".to_string(),
            ));
        }

        let projects = match response.records.unwrap() {
            proto::select_dimension_records_response::Records::ProjectRecords(catalogue) => {
                catalogue
                    .records
                    .into_iter()
                    .map(|record| {
                        Ok(Project {
                            id: Uuid::parse_str(&record.id)
                                .map_err(|err| DataConversionError(err.to_string()))?,
                            name: record.name,
                            description: record.description,
                            create_time: from_proto_timestamp(record.create_time.unwrap())?,
                        })
                    })
                    .collect::<Result<Vec<Project>, ClientError>>()?
            }
        };

        Ok(projects)
    }
}

pub fn from_proto_timestamp(timestamp: prost_types::Timestamp) -> Result<UtcDateTime, ClientError> {
    use ClientError::DataConversionError;

    let nanos = timestamp
        .nanos
        .try_into()
        .map_err(|_err| DataConversionError("negative nanoseconds".to_string()))?;

    match chrono::Utc.timestamp_opt(timestamp.seconds, nanos) {
        chrono::LocalResult::None => Err(DataConversionError(
            "out-of-range number of seconds and/or invalid nanosecond".to_string(),
        )),
        chrono::LocalResult::Single(datetime) => Ok(datetime),
        chrono::LocalResult::Ambiguous(_, _) => Err(DataConversionError(
            "Given local time representation has multiple results and thus ambiguous.".to_string(),
        )),
    }
}
