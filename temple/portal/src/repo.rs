use crate::{util, PortalError, PortalErrorCode, PortalResult};
use foundation::{datastore, model, project, FoundationError, FoundationResult};

mod proto {
    pub mod models {
        tonic::include_proto!("proto.gymnasium.v1.models");
    }

    pub mod projects {
        tonic::include_proto!("proto.gymnasium.v1.projects");
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

#[async_trait::async_trait]
impl model::list::ListModels for Repo {
    async fn list_models(
        &self,
        project_slug: &str,
    ) -> FoundationResult<Vec<datastore::model::Model>> {
        self.list_models(project_slug.to_owned())
            .await
            .map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl model::create::CreateModel for Repo {
    async fn get_project(&self, slug: &str) -> FoundationResult<datastore::project::Project> {
        self.get_project(slug.to_owned()).await.map_err(Into::into)
    }

    async fn create_model(
        &self,
        project_record: datastore::project::Project,
        model: model::Model,
    ) -> FoundationResult<datastore::model::Model> {
        self.create_model(project_record, model)
            .await
            .map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl model::delete::DeleteModel for Repo {
    async fn get_model(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::Model> {
        self.find_project_model(project_slug.to_owned(), model_slug.to_owned())
            .await
            .map_err(Into::into)
    }

    async fn delete_model(&self, model: datastore::model::Model) -> FoundationResult<()> {
        self.delete_model(model).await.map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl model::create_attribute::CreateModelAttribute for Repo {
    async fn get_model(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::Model> {
        self.find_project_model(project_slug.to_owned(), model_slug.to_owned())
            .await
            .map_err(Into::into)
    }
    async fn create_model_attribute(
        &self,
        model_record: datastore::model::Model,
        attribute: model::Attribute,
    ) -> FoundationResult<datastore::model::Attribute> {
        self.create_model_attribute(model_record, attribute)
            .await
            .map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl model::delete_attribute::DeleteModelAttribute for Repo {
    async fn get_model_attribute(
        &self,
        project_slug: &str,
        model_slug: &str,
        model_attribute_name: &str,
    ) -> FoundationResult<datastore::model::Attribute> {
        self.get_model_attribute(
            project_slug.to_owned(),
            model_slug.to_owned(),
            model_attribute_name.to_owned(),
        )
        .await
        .map_err(Into::into)
    }

    async fn delete_model_attribute(
        &self,
        model_attribute: datastore::model::Attribute,
    ) -> FoundationResult<()> {
        self.delete_model_attribute(model_attribute)
            .await
            .map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl model::create_association::CreateModelAssociation for Repo {
    async fn get_model(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::Model> {
        self.find_project_model(project_slug.to_owned(), model_slug.to_owned())
            .await
            .map_err(Into::into)
    }
    async fn create_model_association(
        &self,
        model_record: datastore::model::Model,
        associated_model_record: datastore::model::Model,
        association: model::Association,
    ) -> FoundationResult<datastore::model::Association> {
        self.create_model_association(model_record, associated_model_record, association)
            .await
            .map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl model::delete_association::DeleteModelAssociation for Repo {
    async fn get_model_association(
        &self,
        project_slug: &str,
        model_slug: &str,
        model_association_name: &str,
    ) -> FoundationResult<datastore::model::Association> {
        self.get_model_association(
            project_slug.to_owned(),
            model_slug.to_owned(),
            model_association_name.to_owned(),
        )
        .await
        .map_err(Into::into)
    }

    async fn delete_model_association(
        &self,
        model_association: datastore::model::Association,
    ) -> FoundationResult<()> {
        self.delete_model_association(model_association)
            .await
            .map_err(Into::into)
    }
}

#[async_trait::async_trait]
impl model::get::GetModelOverview for Repo {
    async fn get_model_overview(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::ModelOverview> {
        let model_overview = self
            .get_model_overview(project_slug.to_owned(), model_slug.to_owned())
            .await?;

        Ok(model_overview)
    }
}

#[async_trait::async_trait]
impl model::get_class_diagram::GetModel for Repo {
    async fn get_model(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<model::get_class_diagram::GetModelResponse> {
        let model_overview = self
            .get_model_overview(project_slug.to_owned(), model_slug.to_owned())
            .await?;

        let response = model::get_class_diagram::GetModelResponse {
            model: model_overview.model,
            associations: model_overview.associations,
            attributes: model_overview.attributes,
        };

        Ok(response)
    }
}

#[async_trait::async_trait]
impl model::get_project_class_diagram::ListModelOverviews for Repo {
    async fn list_model_overviews(
        &self,
        project_slug: &str,
    ) -> FoundationResult<Vec<datastore::model::ModelOverview>> {
        let model_overviews = self.list_model_overviews(project_slug.to_owned()).await?;

        Ok(model_overviews)
    }
}

impl Repo {
    async fn projects_client(
        &self,
    ) -> PortalResult<proto::projects::projects_client::ProjectsClient<tonic::transport::Channel>>
    {
        proto::projects::projects_client::ProjectsClient::connect(self.connection_string.clone())
            .await
            .map_err(|err| PortalError::internal(err.to_string()))
    }

    async fn models_client(
        &self,
    ) -> PortalResult<proto::models::models_client::ModelsClient<tonic::transport::Channel>> {
        proto::models::models_client::ModelsClient::connect(self.connection_string.clone())
            .await
            .map_err(|err| PortalError::internal(err.to_string()))
    }

    async fn list_projects(&self) -> PortalResult<Vec<datastore::project::Project>> {
        let mut client = self.projects_client().await?;

        let response = client
            .list_projects(proto::projects::ListProjectsRequest {
                archive_state: proto::projects::ProjectArchiveState::NotArchived.into(),
            })
            .await?
            .into_inner();

        let projects = response
            .projects
            .into_iter()
            .map(datastore_project)
            .collect::<PortalResult<Vec<datastore::project::Project>>>()?;

        Ok(projects)
    }

    async fn list_archived_projects(&self) -> PortalResult<Vec<datastore::project::Project>> {
        let mut client = self.projects_client().await?;

        let response = client
            .list_projects(proto::projects::ListProjectsRequest {
                archive_state: proto::projects::ProjectArchiveState::Archived.into(),
            })
            .await?
            .into_inner();

        let projects = response
            .projects
            .into_iter()
            .map(datastore_project)
            .collect::<PortalResult<Vec<datastore::project::Project>>>()?;

        Ok(projects)
    }

    async fn get_project(&self, slug: String) -> PortalResult<datastore::project::Project> {
        let mut client = self.projects_client().await?;

        let proto_project = client
            .find_project(proto::projects::FindProjectRequest { slug })
            .await?
            .into_inner();

        let project = datastore_project(proto_project)?;

        Ok(project)
    }

    async fn create_project(
        &self,
        project: project::Project,
    ) -> PortalResult<datastore::project::Project> {
        let mut client = self.projects_client().await?;

        let proto_project = client
            .create_project(proto::projects::CreateProjectRequest {
                description: project.description.unwrap_or_default(),
                name: project.name,
                slug: project.slug,
            })
            .await?
            .into_inner();

        let project = datastore_project(proto_project)?;

        Ok(project)
    }

    async fn archive_project(&self, project: datastore::project::Project) -> PortalResult<()> {
        let mut client = self.projects_client().await?;

        client
            .archive_project(proto::projects::ArchiveProjectRequest {
                id: project.id.to_string(),
            })
            .await?;

        Ok(())
    }

    async fn restore_project(&self, project: datastore::project::Project) -> PortalResult<()> {
        let mut client = self.projects_client().await?;

        client
            .restore_project(proto::projects::RestoreProjectRequest {
                id: project.id.to_string(),
            })
            .await?;

        Ok(())
    }

    async fn delete_project(&self, project: datastore::project::Project) -> PortalResult<()> {
        let mut client = self.projects_client().await?;

        client
            .delete_project(proto::projects::DeleteProjectRequest {
                id: project.id.to_string(),
            })
            .await?;

        Ok(())
    }

    async fn rename_project(
        &self,
        project: datastore::project::Project,
    ) -> PortalResult<datastore::project::Project> {
        let mut client = self.projects_client().await?;

        let proto_project = client
            .rename_project(proto::projects::RenameProjectRequest {
                id: project.id.to_string(),
                name: project.name,
                slug: project.slug,
            })
            .await?
            .into_inner();

        let project = datastore_project(proto_project)?;

        Ok(project)
    }

    async fn find_project_model(
        &self,
        project_slug: String,
        model_slug: String,
    ) -> PortalResult<datastore::model::Model> {
        let mut client = self.models_client().await?;

        let proto_model = client
            .find_project_model(proto::models::FindProjectModelRequest {
                project_slug,
                model_slug,
            })
            .await?
            .into_inner();

        let model = datastore_model(proto_model)?;

        Ok(model)
    }

    async fn get_model_overview(
        &self,
        project_slug: String,
        model_slug: String,
    ) -> PortalResult<datastore::model::ModelOverview> {
        let mut client = self.models_client().await?;

        let proto_model_overview = client
            .find_project_model_overview(proto::models::FindProjectModelOverviewRequest {
                project_slug: project_slug.clone(),
                model_slug: model_slug.clone(),
            })
            .await?
            .into_inner();

        let model_overview = datastore::model::ModelOverview {
            model: proto_model_overview
                .model
                .map(datastore_model)
                .transpose()?
                .ok_or(PortalError::internal("".to_string()))?,
            associations: proto_model_overview
                .associations
                .into_iter()
                .map(datastore_model_association)
                .collect::<PortalResult<Vec<datastore::model::Association>>>()?,
            attributes: proto_model_overview
                .attributes
                .into_iter()
                .map(datastore_model_attribute)
                .collect::<PortalResult<Vec<datastore::model::Attribute>>>()?,
        };

        Ok(model_overview)
    }

    async fn list_model_overviews(
        &self,
        project_slug: String,
    ) -> PortalResult<Vec<datastore::model::ModelOverview>> {
        let mut client = self.models_client().await?;

        let model_overviews = client
            .list_project_model_overviews(proto::models::ListProjectModelOverviewsRequest {
                project_slug,
            })
            .await?
            .into_inner()
            .model_overviews
            .into_iter()
            .map(|proto_model_overview| {
                Ok(datastore::model::ModelOverview {
                    model: proto_model_overview
                        .model
                        .map(datastore_model)
                        .transpose()?
                        .ok_or(PortalError::internal("".to_string()))?,
                    associations: proto_model_overview
                        .associations
                        .into_iter()
                        .map(datastore_model_association)
                        .collect::<PortalResult<Vec<datastore::model::Association>>>()?,
                    attributes: proto_model_overview
                        .attributes
                        .into_iter()
                        .map(datastore_model_attribute)
                        .collect::<PortalResult<Vec<datastore::model::Attribute>>>()?,
                })
            })
            .collect::<PortalResult<Vec<datastore::model::ModelOverview>>>()?;

        Ok(model_overviews)
    }

    async fn list_models(
        &self,
        project_slug: String,
    ) -> PortalResult<Vec<datastore::model::Model>> {
        let mut client = self.models_client().await?;

        let response = client
            .list_project_models(proto::models::ListProjectModelsRequest { project_slug })
            .await?
            .into_inner();

        let models = response
            .models
            .into_iter()
            .map(datastore_model)
            .collect::<PortalResult<Vec<datastore::model::Model>>>()?;

        Ok(models)
    }

    async fn create_model(
        &self,
        project_record: datastore::project::Project,
        model: model::Model,
    ) -> PortalResult<datastore::model::Model> {
        let mut client = self.models_client().await?;

        let proto_model = client
            .create_model(proto::models::CreateModelRequest {
                project_id: project_record.id.to_string(),
                description: model.description.unwrap_or_default(),
                name: model.name,
                slug: model.slug,
            })
            .await?
            .into_inner();

        let model = datastore_model(proto_model)?;

        Ok(model)
    }

    async fn delete_model(&self, model: datastore::model::Model) -> PortalResult<()> {
        let mut client = self.models_client().await?;

        client
            .delete_model(proto::models::DeleteModelRequest {
                id: model.id.to_string(),
            })
            .await?;

        Ok(())
    }

    async fn create_model_attribute(
        &self,
        model_record: datastore::model::Model,
        model_attribute: model::Attribute,
    ) -> PortalResult<datastore::model::Attribute> {
        let mut client = self.models_client().await?;

        let proto_attribute = client
            .create_attribute(proto::models::CreateAttributeRequest {
                model_id: model_record.id.to_string(),
                description: model_attribute.description.unwrap_or_default(),
                name: model_attribute.name,
                kind: match model_attribute.kind {
                    model::AttributeKind::String => proto::models::AttributeKind::String,
                    model::AttributeKind::Integer => proto::models::AttributeKind::Integer,
                    model::AttributeKind::Boolean => proto::models::AttributeKind::Boolean,
                }
                .into(),
            })
            .await?
            .into_inner();

        let attribute = datastore_model_attribute(proto_attribute)?;

        Ok(attribute)
    }

    async fn get_model_attribute(
        &self,
        project_slug: String,
        model_slug: String,
        attribute_name: String,
    ) -> PortalResult<datastore::model::Attribute> {
        let mut client = self.models_client().await?;

        let proto_model_attribute = client
            .find_project_model_attribute(proto::models::FindProjectModelAttributeRequest {
                project_slug,
                model_slug,
                attribute_name,
            })
            .await?
            .into_inner();

        let attribute = datastore_model_attribute(proto_model_attribute)?;

        Ok(attribute)
    }

    async fn delete_model_attribute(
        &self,
        model_attribute: datastore::model::Attribute,
    ) -> PortalResult<()> {
        let mut client = self.models_client().await?;

        client
            .delete_attribute(proto::models::DeleteAttributeRequest {
                id: model_attribute.id.to_string(),
            })
            .await?;

        Ok(())
    }

    async fn create_model_association(
        &self,
        model_record: datastore::model::Model,
        associated_model_record: datastore::model::Model,
        model_association: model::Association,
    ) -> PortalResult<datastore::model::Association> {
        let mut client = self.models_client().await?;


        let proto_model_association = client
            .create_association(proto::models::CreateAssociationRequest {
                model_id: model_record.id.to_string(),
                associated_model_id: associated_model_record.id.to_string(),
                description: model_association.description.unwrap_or_default(),
                name: model_association.name,
                kind: match model_association.kind {
                    model::AssociationKind::HasMany => proto::models::AssociationKind::HasMany,
                    model::AssociationKind::HasOne => proto::models::AssociationKind::HasOne,
                    model::AssociationKind::BelongsTo => proto::models::AssociationKind::BelongsTo,
                }
                .into(),
            })
            .await?
            .into_inner();

        let association = datastore_model_association(proto_model_association)?;

        Ok(association)
    }

    async fn get_model_association(
        &self,
        project_slug: String,
        model_slug: String,
        association_name: String,
    ) -> PortalResult<datastore::model::Association> {
        let mut client = self.models_client().await?;

        let proto_model_association = client
            .find_project_model_association(proto::models::FindProjectModelAssociationRequest {
                project_slug,
                model_slug,
                association_name,
            })
            .await?
            .into_inner();

        let association = datastore_model_association(proto_model_association)?;

        Ok(association)
    }

    async fn delete_model_association(
        &self,
        model_association: datastore::model::Association,
    ) -> PortalResult<()> {
        let mut client = self.models_client().await?;

        client
            .delete_association(proto::models::DeleteAssociationRequest {
                id: model_association.id.to_string(),
            })
            .await?;

        Ok(())
    }
}

fn datastore_project(
    proto_project: proto::projects::Project,
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

fn datastore_model(proto_model: proto::models::Model) -> PortalResult<datastore::model::Model> {
    let create_time = proto_model
        .create_time
        .ok_or(PortalError::internal("missing #create_time for Model"))?;

    let update_time = proto_model
        .update_time
        .ok_or(PortalError::internal("missing #update_time for Model"))?;

    let model = datastore::model::Model {
        id: util::proto::uuid_from_proto_string(&proto_model.id, "id")?,
        project_id: util::proto::uuid_from_proto_string(&proto_model.project_id, "project_id")?,
        description: proto_model.description,
        name: proto_model.name,
        slug: proto_model.slug,
        inserted_at: util::proto::from_proto_timestamp(create_time, "insert_time")?,
        updated_at: util::proto::from_proto_timestamp(update_time, "update_time")?,
    };

    Ok(model)
}

fn datastore_model_attribute(
    proto_model_attribute: proto::models::Attribute,
) -> PortalResult<datastore::model::Attribute> {
    use proto::models::AttributeKind;

    let create_time = proto_model_attribute
        .create_time
        .ok_or(PortalError::internal("missing #create_time for Model"))?;

    let update_time = proto_model_attribute
        .update_time
        .ok_or(PortalError::internal("missing #update_time for Model"))?;

    let proto_model_attribute_kind =
        proto::models::AttributeKind::from_i32(proto_model_attribute.kind)
            .ok_or(PortalError::internal("missing #kind for ModelAttribute"))?;

    let model_attribute = datastore::model::Attribute {
        id: util::proto::uuid_from_proto_string(&proto_model_attribute.id, "id")?,
        model_id: util::proto::uuid_from_proto_string(&proto_model_attribute.model_id, "model_id")?,
        description: proto_model_attribute.description,
        kind: match proto_model_attribute_kind {
            AttributeKind::Unspecified => {
                return Err(PortalError::internal("UnspecifiedAttributeKind"))
            }
            AttributeKind::String => datastore::model::AttributeKind::String,
            AttributeKind::Integer => datastore::model::AttributeKind::Integer,
            AttributeKind::Boolean => datastore::model::AttributeKind::Boolean,
        },
        name: proto_model_attribute.name,
        inserted_at: util::proto::from_proto_timestamp(create_time, "insert_time")?,
        updated_at: util::proto::from_proto_timestamp(update_time, "update_time")?,
    };

    Ok(model_attribute)
}

fn datastore_model_association(
    proto_model_association: proto::models::Association,
) -> PortalResult<datastore::model::Association> {
    use proto::models::AssociationKind::*;

    let create_time = proto_model_association
        .create_time
        .ok_or(PortalError::internal("missing #create_time for Model"))?;

    let update_time = proto_model_association
        .update_time
        .ok_or(PortalError::internal("missing #update_time for Model"))?;

    let proto_model_association_kind =
        proto::models::AssociationKind::from_i32(proto_model_association.kind)
            .ok_or(PortalError::internal("missing #kind for ModelAttribute"))?;

    let associated_model =
        proto_model_association
            .associated_model
            .ok_or(PortalError::internal(
                "missing #associated_model for ModelAssociation",
            ))?;

    let model_attribute = datastore::model::Association {
        id: util::proto::uuid_from_proto_string(&proto_model_association.id, "id")?,
        model_id: util::proto::uuid_from_proto_string(
            &proto_model_association.model_id,
            "model_id",
        )?,
        associated_model: datastore_model(associated_model)?,
        description: proto_model_association.description,
        kind: match proto_model_association_kind {
            Unspecified => return Err(PortalError::internal("UnspecifiedAttributeKind")),
            BelongsTo => datastore::model::AssociationKind::BelongsTo,
            HasOne => datastore::model::AssociationKind::HasOne,
            HasMany => datastore::model::AssociationKind::HasMany,
        },
        name: proto_model_association.name,
        inserted_at: util::proto::from_proto_timestamp(create_time, "insert_time")?,
        updated_at: util::proto::from_proto_timestamp(update_time, "update_time")?,
    };

    Ok(model_attribute)
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
