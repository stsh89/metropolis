use crate::{
    model::{Project, Uuid},
    util, AppError, AppResult,
};
use tonic::transport::Channel;

pub mod proto {
    tonic::include_proto!("proto.gymnasium.v1");

    pub mod dimensions {
        tonic::include_proto!("proto.gymnasium.v1.dimensions");
    }
}

#[derive(Default, Debug)]
pub struct Repo {
    pub connection_string: String,
}

pub struct SelectProjectsAttributes {
    pub archived: bool,
}

impl Repo {
    async fn connect(&self) -> AppResult<proto::dimensions_client::DimensionsClient<Channel>> {
        proto::dimensions_client::DimensionsClient::connect(self.connection_string.clone())
            .await
            .map_err(|err| AppError::internal(err.to_string()))
    }

    pub async fn select_projects(
        &self,
        attributes: SelectProjectsAttributes,
    ) -> AppResult<Vec<Project>> {
        let SelectProjectsAttributes { archived } = attributes;

        let mut client = self.connect().await?;

        let response = client
            .select_dimension_records(proto::SelectDimensionRecordsRequest {
                record_parameters: Some(
                    proto::select_dimension_records_request::RecordParameters::ProjectRecordParameters(
                        proto::ProjectRecordParameters {
                            archived,
                        },
                    ),
                ),
            })
            .await?
            .into_inner();

        let Some(records) = response.records else {
            return Err(AppError::internal("missing #records for select_dimension_records response"));
        };

        match records {
            proto::select_dimension_records_response::Records::ProjectRecords(catalogue) => {
                catalogue
                    .records
                    .into_iter()
                    .map(from_proto_project)
                    .collect::<AppResult<Vec<Project>>>()
            }
        }
    }

    pub async fn create_project(&self, project: Project) -> AppResult<Project> {
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
                            archivation_time: Default::default(),
                        },
                    ),
                ),
            })
            .await?
            .into_inner();

        let Some(record) = response.record else {
            return Err(AppError::internal("missing #record for store_dimension_record response"));
        };

        match record {
            proto::store_dimension_record_response::Record::ProjectRecord(proto_project) => {
                from_proto_project(proto_project)
            }
        }
    }

    pub async fn update_project(&self, project: Project) -> AppResult<Project> {
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
                            archivation_time: project
                                .archivation_time
                                .map(util::proto::to_proto_timestamp),
                            create_time: Some(util::proto::to_proto_timestamp(project.create_time)),
                        },
                    ),
                ),
            })
            .await?
            .into_inner();

        let Some(record) = response.record else {
            return Err(AppError::internal("missing #record for store_dimension_record response"));
        };

        match record {
            proto::store_dimension_record_response::Record::ProjectRecord(proto_project) => {
                from_proto_project(proto_project)
            }
        }
    }

    pub async fn find_project(&self, slug: &str) -> AppResult<Project> {
        let mut client = self.connect().await?;

        let response = client
            .find_dimension_record(proto::FindDimensionRecordRequest {
                id: Some(proto::find_dimension_record_request::Id::ProjectRecordSlug(
                    slug.to_owned(),
                )),
            })
            .await?
            .into_inner();

        let Some(record) = response.record else {
            return Err(AppError::internal("missing #record for find_dimension_record response"));
        };

        match record {
            proto::find_dimension_record_response::Record::ProjectRecord(proto_project) => {
                from_proto_project(proto_project)
            }
        }
    }

    pub async fn get_project(&self, id: Uuid) -> AppResult<Project> {
        let mut client = self.connect().await?;

        let response = client
            .find_dimension_record(proto::FindDimensionRecordRequest {
                id: Some(proto::find_dimension_record_request::Id::ProjectRecordId(
                    id.to_string(),
                )),
            })
            .await?
            .into_inner();

        let Some(record) = response.record else {
            return Err(AppError::internal("missing #record for find_dimension_record response"));
        };

        match record {
            proto::find_dimension_record_response::Record::ProjectRecord(proto_project) => {
                from_proto_project(proto_project)
            }
        }
    }

    pub async fn delete_project(&self, project: Project) -> AppResult<()> {
        let mut client = self.connect().await?;

        client
            .remove_dimension_record(proto::RemoveDimensionRecordRequest {
                id: Some(proto::remove_dimension_record_request::Id::ProjectRecordId(
                    project.id.to_string(),
                )),
            })
            .await?;

        Ok(())
    }
}

fn from_proto_project(proto_project: proto::dimensions::Project) -> AppResult<Project> {
    let Some(create_time) = proto_project.create_time else {
        return Err(AppError::internal("missing #create_time for Project"))
    };

    Ok(Project {
        archivation_time: proto_project
            .archivation_time
            .map(|timestamp| util::proto::from_proto_timestamp(timestamp, "archivation_time"))
            .transpose()?,
        create_time: util::proto::from_proto_timestamp(create_time, "create_time")?,
        description: proto_project.description,
        id: util::proto::uuid_from_proto_string(&proto_project.id, "id")?,
        name: proto_project.name,
        slug: proto_project.slug,
    })
}
