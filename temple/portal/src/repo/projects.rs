use super::map_status_error;
use crate::util;
use foundation::{
    datastore,
    project::{
        ArchiveProjectRecord, CreateProjectRecord, DeleteProjectRecord, GetProjectRecord,
        ListProjectRecordFilterArchive, ListProjectRecordFilters, ListProjectRecords, Project,
        RenameProjectRecord, RestoreProjectRecord,
    },
    FoundationError, FoundationResult,
};

mod rpc {
    tonic::include_proto!("proto.gymnasium.v1.projects");
}

pub struct ProjectsRepo {
    pub connection_string: String,
}

#[async_trait::async_trait]
impl CreateProjectRecord for ProjectsRepo {
    async fn create_project_record(
        &self,
        project: Project,
    ) -> FoundationResult<datastore::project::Project> {
        let mut client = self.client().await?;

        let proto_project = client
            .create_project(rpc::CreateProjectRequest {
                description: project.description.unwrap_or_default(),
                name: project.name,
                slug: project.slug,
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let project = datastore_project(proto_project)?;

        Ok(project)
    }
}

#[async_trait::async_trait]
impl GetProjectRecord for ProjectsRepo {
    async fn get_project_record(
        &self,
        slug: &str,
    ) -> FoundationResult<datastore::project::Project> {
        let mut client = self.client().await?;

        let proto_project = client
            .find_project(rpc::FindProjectRequest {
                slug: slug.to_owned(),
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let project = datastore_project(proto_project)?;

        Ok(project)
    }
}

#[async_trait::async_trait]
impl ListProjectRecords for ProjectsRepo {
    async fn list_project_records(
        &self,
        filters: ListProjectRecordFilters,
    ) -> FoundationResult<Vec<datastore::project::Project>> {
        let mut client = self.client().await?;

        let archive_state = match filters.archive_filter {
            ListProjectRecordFilterArchive::Any => rpc::ProjectArchiveState::Any,
            ListProjectRecordFilterArchive::ArchivedOnly => rpc::ProjectArchiveState::Archived,
            ListProjectRecordFilterArchive::NotArchivedOnly => {
                rpc::ProjectArchiveState::NotArchived
            }
        }
        .into();

        let response = client
            .list_projects(rpc::ListProjectsRequest { archive_state })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let projects = response
            .projects
            .into_iter()
            .map(datastore_project)
            .collect::<FoundationResult<Vec<datastore::project::Project>>>()?;

        Ok(projects)
    }
}

#[async_trait::async_trait]
impl ArchiveProjectRecord for ProjectsRepo {
    async fn archive_project_record(
        &self,
        project: datastore::project::Project,
    ) -> FoundationResult<()> {
        let mut client = self.client().await?;

        client
            .archive_project(rpc::ArchiveProjectRequest {
                id: project.id.to_string(),
            })
            .await
            .map_err(map_status_error)?;

        Ok(())
    }
}

#[async_trait::async_trait]
impl DeleteProjectRecord for ProjectsRepo {
    async fn delete_project_record(
        &self,
        project: datastore::project::Project,
    ) -> FoundationResult<()> {
        let mut client = self.client().await?;

        client
            .delete_project(rpc::DeleteProjectRequest {
                id: project.id.to_string(),
            })
            .await
            .map_err(map_status_error)?;

        Ok(())
    }
}

#[async_trait::async_trait]
impl RestoreProjectRecord for ProjectsRepo {
    async fn restore_project_record(
        &self,
        project: datastore::project::Project,
    ) -> FoundationResult<()> {
        let mut client = self.client().await?;

        client
            .restore_project(rpc::RestoreProjectRequest {
                id: project.id.to_string(),
            })
            .await
            .map_err(map_status_error)?;

        Ok(())
    }
}

#[async_trait::async_trait]
impl RenameProjectRecord for ProjectsRepo {
    async fn rename_project_record(
        &self,
        project: datastore::project::Project,
    ) -> FoundationResult<datastore::project::Project> {
        let mut client = self.client().await?;

        let proto_project = client
            .rename_project(rpc::RenameProjectRequest {
                id: project.id.to_string(),
                name: project.name,
                slug: project.slug,
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let project = datastore_project(proto_project)?;

        Ok(project)
    }
}

impl ProjectsRepo {
    async fn client(
        &self,
    ) -> FoundationResult<rpc::projects_client::ProjectsClient<tonic::transport::Channel>> {
        rpc::projects_client::ProjectsClient::connect(self.connection_string.clone())
            .await
            .map_err(|err| FoundationError::internal(err.to_string()))
    }
}

fn datastore_project(proto_project: rpc::Project) -> FoundationResult<datastore::project::Project> {
    let create_time = proto_project.create_time.ok_or(FoundationError::internal(
        "missing #create_time for Project",
    ))?;

    let update_time = proto_project.update_time.ok_or(FoundationError::internal(
        "missing #update_time for Project",
    ))?;

    let project = datastore::project::Project {
        id: util::proto::uuid_from_proto_string(&proto_project.id, "id")
            .map_err(map_status_error)?,
        archived_at: proto_project
            .archive_time
            .map(|timestamp| util::proto::from_proto_timestamp(timestamp, "archive_time"))
            .transpose()
            .map_err(map_status_error)?,
        description: proto_project.description,
        name: proto_project.name,
        slug: proto_project.slug,
        inserted_at: util::proto::from_proto_timestamp(create_time, "insert_time")
            .map_err(map_status_error)?,
        updated_at: util::proto::from_proto_timestamp(update_time, "update_time")
            .map_err(map_status_error)?,
    };

    Ok(project)
}
