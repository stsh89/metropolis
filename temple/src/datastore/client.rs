use crate::{helpers, model::Project};
use tonic::transport::Channel;
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
    Connection(String),
    EndpointRequest(String),
    DataConversion(String),
}

impl ClientError {
    pub fn description(&self) -> &str {
        match self {
            ClientError::Connection(description) => description,
            ClientError::EndpointRequest(description) => description,
            ClientError::DataConversion(description) => description,
        }
    }
}

impl Client {
    async fn connect(
        &self,
    ) -> Result<proto::dimensions_client::DimensionsClient<Channel>, ClientError> {
        use ClientError::*;

        proto::dimensions_client::DimensionsClient::connect("http://localhost:50052")
            .await
            .map_err(|err| Connection(err.to_string()))
    }

    pub async fn select_projects(&self) -> Result<Vec<Project>, ClientError> {
        use ClientError::*;

        let mut client = self.connect().await?;

        let response = client
            .select_dimension_records(proto::SelectDimensionRecordsRequest {
                record_parameters: Some(
                    proto::select_dimension_records_request::RecordParameters::ProjectRecordParameters(
                        proto::ProjectRecordParameters {},
                    ),
                ),
            })
            .await
            .map_err(|err| EndpointRequest(err.to_string()))?
            .into_inner();

        let Some(records) = response.records else {
            return Err(EndpointRequest(
                "missing required field: #records".to_string(),
            ));
        };

        match records {
            proto::select_dimension_records_response::Records::ProjectRecords(catalogue) => {
                catalogue
                    .records
                    .into_iter()
                    .map(from_proto_project)
                    .collect::<Result<Vec<Project>, ClientError>>()
            }
        }
    }

    pub async fn create_project(&self, project: Project) -> Result<Project, ClientError> {
        use ClientError::*;

        let mut client = self.connect().await?;

        let response = client
            .store_dimension_record(proto::StoreDimensionRecordRequest {
                record: Some(
                    proto::store_dimension_record_request::Record::ProjectRecord(
                        proto::dimensions::Project {
                            id: Default::default(),
                            name: project.name,
                            slug: project.slug,
                            description: project.description,
                            create_time: Default::default(),
                        },
                    ),
                ),
            })
            .await
            .map_err(|err| EndpointRequest(err.to_string()))?
            .into_inner();

        let Some(record) = response.record else {
            return Err(EndpointRequest(
                "missing required field: #record".to_string(),
            ));
        };

        match record {
            proto::store_dimension_record_response::Record::ProjectRecord(proto_project) => {
                from_proto_project(proto_project)
            }
        }
    }

    pub async fn update_project(&self, project: Project) -> Result<Project, ClientError> {
        use ClientError::*;

        let mut client = self.connect().await?;

        let response = client
            .store_dimension_record(proto::StoreDimensionRecordRequest {
                record: Some(
                    proto::store_dimension_record_request::Record::ProjectRecord(
                        proto::dimensions::Project {
                            id: project.id.to_string(),
                            name: project.name,
                            slug: project.slug,
                            description: project.description,
                            create_time: Some(helpers::to_proto_timestamp(project.create_time)),
                        },
                    ),
                ),
            })
            .await
            .map_err(|err| EndpointRequest(err.to_string()))?
            .into_inner();

        let Some(record) = response.record else {
            return Err(EndpointRequest(
                "missing required field: #record".to_string(),
            ));
        };

        match record {
            proto::store_dimension_record_response::Record::ProjectRecord(proto_project) => {
                from_proto_project(proto_project)
            }
        }
    }

    pub async fn find_project(&self, slug: &str) -> Result<Project, ClientError> {
        use ClientError::*;

        let mut client = self.connect().await?;

        let response = client
            .find_dimension_record(proto::FindDimensionRecordRequest {
                id: Some(proto::find_dimension_record_request::Id::ProjectRecordSlug(
                    slug.to_owned(),
                )),
            })
            .await
            .map_err(|err| EndpointRequest(err.to_string()))?
            .into_inner();

        let Some(record) = response.record else {
            return Err(EndpointRequest(
                "missing required field: #record".to_string(),
            ));
        };

        match record {
            proto::find_dimension_record_response::Record::ProjectRecord(proto_project) => {
                from_proto_project(proto_project)
            }
        }
    }

    pub async fn get_project(&self, id: Uuid) -> Result<Project, ClientError> {
        use ClientError::*;

        let mut client = self.connect().await?;

        let response = client
            .find_dimension_record(proto::FindDimensionRecordRequest {
                id: Some(proto::find_dimension_record_request::Id::ProjectRecordId(
                    id.to_string(),
                )),
            })
            .await
            .map_err(|err| EndpointRequest(err.to_string()))?
            .into_inner();

        let Some(record) = response.record else {
            return Err(EndpointRequest(
                "missing required field: #record".to_string(),
            ));
        };

        match record {
            proto::find_dimension_record_response::Record::ProjectRecord(proto_project) => {
                from_proto_project(proto_project)
            }
        }
    }
}

fn from_proto_project(proto_project: proto::dimensions::Project) -> Result<Project, ClientError> {
    use ClientError::*;

    let Some(create_time) = proto_project.create_time else {
        return Err(DataConversion("missing create time".to_string()))
    };

    Ok(Project {
        id: Uuid::parse_str(&proto_project.id).map_err(|err| DataConversion(err.to_string()))?,
        name: proto_project.name,
        description: proto_project.description,
        slug: proto_project.slug,
        create_time: helpers::from_proto_timestamp(create_time, "create_time")
            .map_err(|err| DataConversion(err.to_string()))?,
    })
}
