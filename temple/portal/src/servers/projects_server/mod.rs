// use crate::{datastore::Repo, model::Project, service, util};
use crate::{
    repo::{ModelsRepo, ProjectsRepo},
    PortalError,
};
use foundation::{
    model::{self, Model},
    project::{self, Project},
};
use tonic::{Request, Response, Status};

mod create_model;

pub mod rpc {
    tonic::include_proto!("proto.temple.v1"); // The string specified here must match the proto package name
}

pub struct ProjectsServer {
    pub projects_repo: ProjectsRepo,
    pub models_repo: ModelsRepo,
}

#[tonic::async_trait]
impl rpc::projects_server::Projects for ProjectsServer {
    async fn list_projects(
        &self,
        request: Request<rpc::ListProjectsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::ListProjectsResponse>, Status> {
        println!("Got a request: {:?}", request);

        let projects: Vec<rpc::Project> = project::list::execute(&self.projects_repo)
            .await
            .map_err(Into::<PortalError>::into)?
            .projects
            .into_iter()
            .map(to_proto_project)
            .collect();

        Ok(Response::new(rpc::ListProjectsResponse { projects }))
    }

    async fn list_archived_projects(
        &self,
        request: Request<rpc::ListArchivedProjectsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::ListArchivedProjectsResponse>, Status> {
        println!("Got a request: {:?}", request);

        let projects: Vec<rpc::Project> = project::list_archived::execute(&self.projects_repo)
            .await
            .map_err(Into::<PortalError>::into)?
            .projects
            .into_iter()
            .map(to_proto_project)
            .collect();

        Ok(Response::new(rpc::ListArchivedProjectsResponse {
            projects,
        }))
    }

    async fn get_project(
        &self,
        request: Request<rpc::GetProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::GetProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::GetProjectRequest { slug } = request.into_inner();

        let project = project::get::execute(&self.projects_repo, project::get::Request { slug })
            .await
            .map_err(Into::<PortalError>::into)?
            .project;

        Ok(Response::new(rpc::GetProjectResponse {
            project: Some(to_proto_project(project)),
        }))
    }

    async fn get_model(
        &self,
        request: Request<rpc::GetModelRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::GetModelResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::GetModelRequest {
            project_slug,
            model_slug,
        } = request.into_inner();

        let response = model::get::execute(
            &self.models_repo,
            model::get::Request {
                project_slug,
                model_slug,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(rpc::GetModelResponse {
            model: Some(to_proto_model(response.model_overview.model)),
            attributes: response
                .model_overview
                .attributes
                .into_iter()
                .map(to_proto_model_attribute)
                .collect(),
            associations: response
                .model_overview
                .associations
                .into_iter()
                .map(to_proto_model_association)
                .collect(),
        }))
    }

    async fn create_project(
        &self,
        request: Request<rpc::CreateProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::CreateProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::CreateProjectRequest { description, name } = request.into_inner();

        let project = project::create::execute(
            &self.projects_repo,
            project::create::Request { description, name },
        )
        .await
        .map_err(Into::<PortalError>::into)?
        .project;

        Ok(Response::new(rpc::CreateProjectResponse {
            project: Some(to_proto_project(project)),
        }))
    }

    async fn archive_project(
        &self,
        request: Request<rpc::ArchiveProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::ArchiveProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::ArchiveProjectRequest { slug } = request.into_inner();

        project::archive::execute(&self.projects_repo, project::archive::Request { slug })
            .await
            .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(rpc::ArchiveProjectResponse {}))
    }

    async fn restore_project(
        &self,
        request: Request<rpc::RestoreProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::RestoreProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::RestoreProjectRequest { slug } = request.into_inner();

        project::restore::execute(&self.projects_repo, project::restore::Request { slug })
            .await
            .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(rpc::RestoreProjectResponse {}))
    }

    async fn delete_project(
        &self,
        request: Request<rpc::DeleteProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::DeleteProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::DeleteProjectRequest { slug } = request.into_inner();

        project::delete::execute(&self.projects_repo, project::delete::Request { slug })
            .await
            .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(rpc::DeleteProjectResponse {}))
    }

    async fn rename_project(
        &self,
        request: Request<rpc::RenameProjectRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::RenameProjectResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::RenameProjectRequest { name, slug } = request.into_inner();

        let project =
            project::rename::execute(&self.projects_repo, project::rename::Request { name, slug })
                .await
                .map_err(Into::<PortalError>::into)?
                .project;

        Ok(Response::new(rpc::RenameProjectResponse {
            project: Some(to_proto_project(project)),
        }))
    }

    async fn list_models(
        &self,
        request: Request<rpc::ListModelsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::ListModelsResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::ListModelsRequest { project_slug } = request.into_inner();

        let models = model::list::execute(&self.models_repo, model::list::Request { project_slug })
            .await
            .map_err(Into::<PortalError>::into)?
            .models
            .into_iter()
            .map(to_proto_model)
            .collect();

        Ok(Response::new(rpc::ListModelsResponse { models }))
    }

    async fn create_model(
        &self,
        request: Request<rpc::CreateModelRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::CreateModelResponse>, Status> {
        println!("Got a request: {:?}", request);

        create_model::execute(self, request).await
    }

    async fn delete_model(
        &self,
        request: Request<rpc::DeleteModelRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::DeleteModelResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::DeleteModelRequest {
            project_slug,
            model_slug,
        } = request.into_inner();

        model::delete::execute(
            &self.models_repo,
            model::delete::Request {
                project_slug,
                model_slug,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(rpc::DeleteModelResponse {}))
    }

    async fn create_model_attribute(
        &self,
        request: Request<rpc::CreateModelAttributeRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::CreateModelAttributeResponse>, Status> {
        use rpc::ModelAttributeKind;

        println!("Got a request: {:?}", request);

        let rpc::CreateModelAttributeRequest {
            project_slug,
            model_slug,
            kind,
            description,
            name,
        } = request.into_inner();

        let Some(attribute_kind) = rpc::ModelAttributeKind::from_i32(kind) else {
            return Err(PortalError::invalid_argument("kind").into());
        };

        let model_attribute = model::create_attribute::execute(
            &self.models_repo,
            model::create_attribute::Request {
                project_slug,
                model_slug,
                description,
                kind: match attribute_kind {
                    ModelAttributeKind::Unspecified => "unspecified",
                    ModelAttributeKind::String => "string",
                    ModelAttributeKind::Integer => "integer",
                    ModelAttributeKind::Boolean => "boolean",
                }
                .to_string(),
                name,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?
        .model_attribute;

        Ok(Response::new(rpc::CreateModelAttributeResponse {
            model_attribute: Some(to_proto_model_attribute(model_attribute)),
        }))
    }

    async fn delete_model_attribute(
        &self,
        request: Request<rpc::DeleteModelAttributeRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::DeleteModelAttributeResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::DeleteModelAttributeRequest {
            project_slug,
            model_slug,
            model_attribute_name,
        } = request.into_inner();

        model::delete_attribute::execute(
            &self.models_repo,
            model::delete_attribute::Request {
                project_slug,
                model_slug,
                model_attribute_name,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(rpc::DeleteModelAttributeResponse {}))
    }

    async fn create_model_association(
        &self,
        request: Request<rpc::CreateModelAssociationRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::CreateModelAssociationResponse>, Status> {
        use rpc::ModelAssociationKind;

        println!("Got a request: {:?}", request);

        let rpc::CreateModelAssociationRequest {
            project_slug,
            model_slug,
            associated_model_slug,
            description,
            kind,
            name,
        } = request.into_inner();

        let Some(association_kind) = rpc::ModelAssociationKind::from_i32(kind) else {
            return Err(PortalError::invalid_argument("kind").into());
        };

        let model_association = model::create_association::execute(
            &self.models_repo,
            model::create_association::Request {
                project_slug,
                model_slug,
                associated_model_slug,
                description,
                kind: match association_kind {
                    ModelAssociationKind::Unspecified => "unspecified",
                    ModelAssociationKind::HasMany => "has_many",
                    ModelAssociationKind::HasOne => "has_one",
                    ModelAssociationKind::BelongsTo => "belongs_to",
                }
                .to_string(),
                name,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?
        .model_association;

        Ok(Response::new(rpc::CreateModelAssociationResponse {
            model_association: Some(to_proto_model_association(model_association)),
        }))
    }

    async fn delete_model_association(
        &self,
        request: Request<rpc::DeleteModelAssociationRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::DeleteModelAssociationResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::DeleteModelAssociationRequest {
            project_slug,
            model_slug,
            model_association_name,
        } = request.into_inner();

        model::delete_association::execute(
            &self.models_repo,
            model::delete_association::Request {
                project_slug,
                model_slug,
                model_association_name,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(rpc::DeleteModelAssociationResponse {}))
    }

    async fn get_model_class_diagram(
        &self,
        request: Request<rpc::GetModelClassDiagramRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::GetModelClassDiagramResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::GetModelClassDiagramRequest {
            project_slug,
            model_slug,
        } = request.into_inner();

        let response = model::get_class_diagram::execute(
            &self.models_repo,
            model::get_class_diagram::Request {
                project_slug,
                model_slug,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(rpc::GetModelClassDiagramResponse {
            diagram: response.diagram,
        }))
    }

    async fn get_project_class_diagram(
        &self,
        request: Request<rpc::GetProjectClassDiagramRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<rpc::GetProjectClassDiagramResponse>, Status> {
        println!("Got a request: {:?}", request);

        let rpc::GetProjectClassDiagramRequest { project_slug } = request.into_inner();

        let response = model::get_project_class_diagram::execute(
            &self.models_repo,
            model::get_project_class_diagram::Request { project_slug },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(rpc::GetProjectClassDiagramResponse {
            diagram: response.diagram,
        }))
    }
}

fn to_proto_project(project: Project) -> rpc::Project {
    rpc::Project {
        description: project.description.unwrap_or_default(),
        name: project.name,
        slug: project.slug,
    }
}

fn to_proto_model(model: Model) -> rpc::Model {
    rpc::Model {
        description: model.description.unwrap_or_default(),
        name: model.name,
        slug: model.slug,
    }
}

fn to_proto_model_association(model_association: model::Association) -> rpc::ModelAssociation {
    use rpc::ModelAssociationKind::*;

    rpc::ModelAssociation {
        description: model_association.description.unwrap_or_default(),
        name: model_association.name,
        kind: match model_association.kind {
            model::AssociationKind::BelongsTo => BelongsTo,
            model::AssociationKind::HasOne => HasOne,
            model::AssociationKind::HasMany => HasMany,
        }
        .into(),
        model: Some(to_proto_model(model_association.model)),
    }
}

fn to_proto_model_attribute(model_attribute: model::Attribute) -> rpc::ModelAttribute {
    use rpc::ModelAttributeKind;

    rpc::ModelAttribute {
        description: model_attribute.description.unwrap_or_default(),
        name: model_attribute.name,
        kind: match model_attribute.kind {
            model::AttributeKind::String => ModelAttributeKind::String,
            model::AttributeKind::Integer => ModelAttributeKind::Integer,
            model::AttributeKind::Boolean => ModelAttributeKind::Boolean,
        }
        .into(),
    }
}
