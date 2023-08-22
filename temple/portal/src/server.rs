// use crate::{datastore::Repo, model::Project, service, util};
use crate::{repo::Repo, PortalError};
use foundation::{
    model::{self, Model},
    project::{self, Project},
};
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

    async fn get_model(
        &self,
        request: Request<proto::GetModelRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::GetModelResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::GetModelRequest {
            project_slug,
            model_slug,
        } = request.into_inner();

        let response = model::get::execute(
            &self.repo,
            model::get::Request {
                project_slug,
                model_slug,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(proto::GetModelResponse {
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

    async fn list_models(
        &self,
        request: Request<proto::ListModelsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::ListModelsResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::ListModelsRequest { project_slug } = request.into_inner();

        let models = model::list::execute(&self.repo, model::list::Request { project_slug })
            .await
            .map_err(Into::<PortalError>::into)?
            .models
            .into_iter()
            .map(to_proto_model)
            .collect();

        Ok(Response::new(proto::ListModelsResponse { models }))
    }

    async fn create_model(
        &self,
        request: Request<proto::CreateModelRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::CreateModelResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::CreateModelRequest {
            project_slug,
            description,
            name,
        } = request.into_inner();

        let model = model::create::execute(
            &self.repo,
            model::create::Request {
                project_slug,
                description,
                name,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?
        .model;

        Ok(Response::new(proto::CreateModelResponse {
            model: Some(to_proto_model(model)),
        }))
    }

    async fn delete_model(
        &self,
        request: Request<proto::DeleteModelRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::DeleteModelResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::DeleteModelRequest {
            project_slug,
            model_slug,
        } = request.into_inner();

        model::delete::execute(
            &self.repo,
            model::delete::Request {
                project_slug,
                model_slug,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(proto::DeleteModelResponse {}))
    }

    async fn create_model_attribute(
        &self,
        request: Request<proto::CreateModelAttributeRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::CreateModelAttributeResponse>, Status> {
        use proto::ModelAttributeKind;

        println!("Got a request: {:?}", request);

        let proto::CreateModelAttributeRequest {
            project_slug,
            model_slug,
            kind,
            description,
            name,
        } = request.into_inner();

        let Some(attribute_kind) = proto::ModelAttributeKind::from_i32(kind) else {
            return Err(PortalError::invalid_argument("kind").into());
        };

        let model_attribute = model::create_attribute::execute(
            &self.repo,
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

        Ok(Response::new(proto::CreateModelAttributeResponse {
            model_attribute: Some(to_proto_model_attribute(model_attribute)),
        }))
    }

    async fn delete_model_attribute(
        &self,
        request: Request<proto::DeleteModelAttributeRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::DeleteModelAttributeResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::DeleteModelAttributeRequest {
            project_slug,
            model_slug,
            model_attribute_name,
        } = request.into_inner();

        model::delete_attribute::execute(
            &self.repo,
            model::delete_attribute::Request {
                project_slug,
                model_slug,
                model_attribute_name,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(proto::DeleteModelAttributeResponse {}))
    }

    async fn create_model_association(
        &self,
        request: Request<proto::CreateModelAssociationRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::CreateModelAssociationResponse>, Status> {
        use proto::ModelAssociationKind;

        println!("Got a request: {:?}", request);

        let proto::CreateModelAssociationRequest {
            project_slug,
            model_slug,
            associated_model_slug,
            description,
            kind,
            name,
        } = request.into_inner();

        let Some(association_kind) = proto::ModelAssociationKind::from_i32(kind) else {
            return Err(PortalError::invalid_argument("kind").into());
        };

        let model_association = model::create_association::execute(
            &self.repo,
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

        Ok(Response::new(proto::CreateModelAssociationResponse {
            model_association: Some(to_proto_model_association(model_association)),
        }))
    }

    async fn delete_model_association(
        &self,
        request: Request<proto::DeleteModelAssociationRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::DeleteModelAssociationResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::DeleteModelAssociationRequest {
            project_slug,
            model_slug,
            model_association_name,
        } = request.into_inner();

        model::delete_association::execute(
            &self.repo,
            model::delete_association::Request {
                project_slug,
                model_slug,
                model_association_name,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(proto::DeleteModelAssociationResponse {}))
    }

    async fn get_model_class_diagram(
        &self,
        request: Request<proto::GetModelClassDiagramRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::GetModelClassDiagramResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::GetModelClassDiagramRequest {
            project_slug,
            model_slug,
        } = request.into_inner();

        let response = model::get_class_diagram::execute(
            &self.repo,
            model::get_class_diagram::Request {
                project_slug,
                model_slug,
            },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(proto::GetModelClassDiagramResponse {
            diagram: response.diagram,
        }))
    }

    async fn get_project_class_diagram(
        &self,
        request: Request<proto::GetProjectClassDiagramRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::GetProjectClassDiagramResponse>, Status> {
        println!("Got a request: {:?}", request);

        let proto::GetProjectClassDiagramRequest { project_slug } = request.into_inner();

        let response = model::get_project_class_diagram::execute(
            &self.repo,
            model::get_project_class_diagram::Request { project_slug },
        )
        .await
        .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(proto::GetProjectClassDiagramResponse {
            diagram: response.diagram,
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

fn to_proto_model(model: Model) -> proto::Model {
    proto::Model {
        description: model.description.unwrap_or_default(),
        name: model.name,
        slug: model.slug,
    }
}

fn to_proto_model_association(model_association: model::Association) -> proto::ModelAssociation {
    use proto::ModelAssociationKind::*;

    proto::ModelAssociation {
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

fn to_proto_model_attribute(model_attribute: model::Attribute) -> proto::ModelAttribute {
    use proto::ModelAttributeKind;

    proto::ModelAttribute {
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
