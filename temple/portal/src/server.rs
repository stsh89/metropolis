// use crate::{datastore::Repo, model::Project, service, util};
use crate::{repo::Repo, PortalError};
use foundation::project::{self, Project};
use tonic::{Request, Response, Status};

pub mod proto {
    tonic::include_proto!("proto.temple.v1"); // The string specified here must match the proto package name
}

pub struct Projects {
    pub repo: Repo,
}

#[tonic::async_trait]
impl proto::projects_server::Projects for Projects {
    async fn list_projects(
        &self,
        request: Request<proto::ListProjectsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::ListProjectsResponse>, Status> {
        println!("Got a request: {:?}", request);

        let projects: Vec<proto::Project> = project::list::execute(&self.repo)
            .await
            .map_err(Into::<PortalError>::into)?
            .projects
            .into_iter()
            .map(to_proto_project)
            .collect();

        Ok(Response::new(proto::ListProjectsResponse { projects }))
    }

    async fn list_archived_projects(
        &self,
        request: Request<proto::ListArchivedProjectsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::ListArchivedProjectsResponse>, Status> {
        println!("Got a request: {:?}", request);

        let projects: Vec<proto::Project> = project::list_archived::execute(&self.repo)
            .await
            .map_err(Into::<PortalError>::into)?
            .projects
            .into_iter()
            .map(to_proto_project)
            .collect();

        Ok(Response::new(proto::ListArchivedProjectsResponse {
            projects,
        }))
    }

    async fn get_project(
        &self,
        request: Request<proto::GetProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::GetProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::GetProjectRequest { slug } = request.into_inner();

        let project = project::get::execute(&self.repo, project::get::Request { slug })
            .await
            .map_err(Into::<PortalError>::into)?
            .project;

        Ok(Response::new(proto::GetProjectResponse {
            project: Some(to_proto_project(project)),
        }))
    }

    async fn create_project(
        &self,
        request: Request<proto::CreateProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::CreateProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::CreateProjectRequest { description, name } = request.into_inner();

        let project =
            project::create::execute(&self.repo, project::create::Request { description, name })
                .await
                .map_err(Into::<PortalError>::into)?
                .project;

        Ok(Response::new(proto::CreateProjectResponse {
            project: Some(to_proto_project(project)),
        }))
    }

    async fn archive_project(
        &self,
        request: Request<proto::ArchiveProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::ArchiveProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::ArchiveProjectRequest { slug } = request.into_inner();

        project::archive::execute(&self.repo, project::archive::Request { slug })
            .await
            .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(proto::ArchiveProjectResponse {}))
    }

    async fn restore_project(
        &self,
        request: Request<proto::RestoreProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::RestoreProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::RestoreProjectRequest { slug } = request.into_inner();

        project::restore::execute(&self.repo, project::restore::Request { slug })
            .await
            .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(proto::RestoreProjectResponse {}))
    }

    async fn delete_project(
        &self,
        request: Request<proto::DeleteProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::DeleteProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::DeleteProjectRequest { slug } = request.into_inner();

        project::delete::execute(&self.repo, project::delete::Request { slug })
            .await
            .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(proto::DeleteProjectResponse {}))
    }

    async fn rename_project(
        &self,
        request: Request<proto::RenameProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::RenameProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::RenameProjectRequest { name, slug } = request.into_inner();

        let project = project::rename::execute(&self.repo, project::rename::Request { name, slug })
            .await
            .map_err(Into::<PortalError>::into)?
            .project;

        Ok(Response::new(proto::RenameProjectResponse {
            project: Some(to_proto_project(project)),
        }))
    }
}

fn to_proto_project(project: Project) -> proto::Project {
    proto::Project {
        description: project.description.unwrap_or_default(),
        name: project.name,
        slug: project.slug,
    }
}
