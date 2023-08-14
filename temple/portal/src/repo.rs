use crate::{util, PortalError, PortalErrorCode, PortalResult};
use foundation::{datastore, project, FoundationError, FoundationResult};

pub mod proto {
    tonic::include_proto!("proto.gymnasium.v1");

    pub mod dimensions {
        tonic::include_proto!("proto.gymnasium.v1.dimensions");
    }
}

pub struct Repo {
    pub connection_string: String,
}

#[async_trait::async_trait]
impl project::list::ListProjects for Repo {
    async fn list_projects(&self) -> FoundationResult<Vec<datastore::project::Project>> {
        self.list_projects().await.map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl project::list_archived::ListProjects for Repo {
    async fn list_projects(&self) -> FoundationResult<Vec<datastore::project::Project>> {
        self.list_archived_projects().await.map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl project::get::GetProject for Repo {
    async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project> {
        self.get_project(slug).await.map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl project::create::CreateProject for Repo {
    async fn create_project(
        &self,
        project: project::Project,
    ) -> FoundationResult<datastore::project::Project> {
        self.create_project(project).await.map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl project::archive::ArchiveProject for Repo {
    async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project> {
        self.get_project(slug).await.map_err(Into::into)
    }

    async fn archive_project(&self, project: datastore::project::Project) -> FoundationResult<()> {
        self.archive_project(project)
            .await
            .map_err(Into::into)
            .map(|_| ())
    }
}

#[async_trait::async_trait]
impl project::restore::RestoreProject for Repo {
    async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project> {
        self.get_project(slug).await.map_err(Into::into)
    }

    async fn restore_project(&self, project: datastore::project::Project) -> FoundationResult<()> {
        self.restore_project(project)
            .await
            .map_err(Into::into)
            .map(|_| ())
    }
}

#[async_trait::async_trait]
impl project::rename::RenameProject for Repo {
    async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project> {
        self.get_project(slug).await.map_err(Into::into)
    }

    async fn rename_project(
        &self,
        project: datastore::project::Project,
    ) -> FoundationResult<datastore::project::Project> {
        self.rename_project(project).await.map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl project::delete::DeleteProject for Repo {
    async fn get_project(&self, slug: String) -> FoundationResult<datastore::project::Project> {
        self.get_project(slug).await.map_err(Into::into)
    }

    async fn delete_project(&self, project: datastore::project::Project) -> FoundationResult<()> {
        self.delete_project(project).await.map_err(Into::into)
    }
}

impl Repo {
    async fn connect(
        &self,
    ) -> PortalResult<proto::dimensions_client::DimensionsClient<tonic::transport::Channel>> {
        proto::dimensions_client::DimensionsClient::connect(self.connection_string.clone())
            .await
            .map_err(|err| PortalError::internal(err.to_string()))
    }

    async fn list_projects(&self) -> PortalResult<Vec<datastore::project::Project>> {
        let mut client = self.connect().await?;

        let response = client
            .list_project_records(proto::ListProjectRecordsRequest { archived: false })
            .await?
            .into_inner();

        let projects = response
            .project_records
            .into_iter()
            .map(from_proto_project)
            .collect::<PortalResult<Vec<datastore::project::Project>>>()?;

        Ok(projects)
    }

    async fn list_archived_projects(&self) -> PortalResult<Vec<datastore::project::Project>> {
        let mut client = self.connect().await?;

        let response = client
            .list_project_records(proto::ListProjectRecordsRequest { archived: true })
            .await?
            .into_inner();

        let projects = response
            .project_records
            .into_iter()
            .map(from_proto_project)
            .collect::<PortalResult<Vec<datastore::project::Project>>>()?;

        Ok(projects)
    }

    async fn get_project(&self, slug: String) -> PortalResult<datastore::project::Project> {
        let mut client = self.connect().await?;

        let response = client
            .get_project_record(proto::GetProjectRecordRequest { slug })
            .await?
            .into_inner();

        let proto_project = response
            .project_record
            .ok_or(PortalError::internal("empty project_record"))?;

        let project = from_proto_project(proto_project)?;

        Ok(project)
    }

    async fn create_project(
        &self,
        project: project::Project,
    ) -> PortalResult<datastore::project::Project> {
        let mut client = self.connect().await?;

        let response = client
            .create_project_record(proto::CreateProjectRecordRequest {
                description: project.description.unwrap_or_default(),
                name: project.name,
                slug: project.slug,
            })
            .await?
            .into_inner();

        let proto_project = response
            .project_record
            .ok_or(PortalError::internal("empty project_record"))?;

        let project = from_proto_project(proto_project)?;

        Ok(project)
    }

    async fn archive_project(
        &self,
        project: datastore::project::Project,
    ) -> PortalResult<datastore::project::Project> {
        let mut client = self.connect().await?;

        let response = client
            .archive_project_record(proto::ArchiveProjectRecordRequest {
                id: project.id.to_string(),
            })
            .await?
            .into_inner();

        let proto_project = response
            .project_record
            .ok_or(PortalError::internal("empty project_record"))?;

        let project = from_proto_project(proto_project)?;

        Ok(project)
    }

    async fn restore_project(
        &self,
        project: datastore::project::Project,
    ) -> PortalResult<datastore::project::Project> {
        let mut client = self.connect().await?;

        let response = client
            .restore_project_record(proto::RestoreProjectRecordRequest {
                id: project.id.to_string(),
            })
            .await?
            .into_inner();

        let proto_project = response
            .project_record
            .ok_or(PortalError::internal("empty project_record"))?;

        let project = from_proto_project(proto_project)?;

        Ok(project)
    }

    async fn delete_project(&self, project: datastore::project::Project) -> PortalResult<()> {
        let mut client = self.connect().await?;

        client
            .delete_project_record(proto::DeleteProjectRecordRequest {
                id: project.id.to_string(),
            })
            .await?;

        Ok(())
    }

    async fn rename_project(
        &self,
        project: datastore::project::Project,
    ) -> PortalResult<datastore::project::Project> {
        let mut client = self.connect().await?;

        let response = client
            .rename_project_record(proto::RenameProjectRecordRequest {
                id: project.id.to_string(),
                name: project.name,
                slug: project.slug,
            })
            .await?
            .into_inner();

        let proto_project = response
            .project_record
            .ok_or(PortalError::internal("empty project_record"))?;

        let project = from_proto_project(proto_project)?;

        Ok(project)
    }
}

fn from_proto_project(
    proto_project: proto::dimensions::Project,
) -> PortalResult<datastore::project::Project> {
    let create_time = proto_project
        .create_time
        .ok_or(PortalError::internal("missing #create_time for Project"))?;

    let update_time = proto_project
        .update_time
        .ok_or(PortalError::internal("missing #update_time for Project"))?;

    let project = datastore::project::Project {
        id: util::proto::uuid_from_proto_string(&proto_project.id, "id")?,
        archived_at: proto_project
            .archive_time
            .map(|timestamp| util::proto::from_proto_timestamp(timestamp, "archive_time"))
            .transpose()?,
        description: proto_project.description,
        name: proto_project.name,
        slug: proto_project.slug,
        inserted_at: util::proto::from_proto_timestamp(create_time, "insert_time")?,
        updated_at: util::proto::from_proto_timestamp(update_time, "update_time")?,
    };

    Ok(project)
}

impl From<PortalError> for FoundationError {
    fn from(value: PortalError) -> Self {
        match value.code() {
            PortalErrorCode::InvalidArgument => Self::invalid_argument(value.message()),
            PortalErrorCode::FailedPrecondition => Self::failed_precondition(value.message()),
            PortalErrorCode::Internal => Self::internal(value.message()),
            _ => Self::internal(value.message()),
        }
    }
}
