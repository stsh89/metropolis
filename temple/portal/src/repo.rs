use crate::{util, PortalError, PortalErrorCode, PortalResult};
use foundation::{datastore, model, project, FoundationError, FoundationResult};

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
        self.get_model(project_slug.to_owned(), model_slug.to_owned())
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
        self.get_model(project_slug.to_owned(), model_slug.to_owned())
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
        self.get_model(project_slug.to_owned(), model_slug.to_owned())
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
impl model::get::GetModel for Repo {
    async fn get_model(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<model::get::GetModelResponse> {
        let (model, associations, attributes) = self
            .get_model_full(project_slug.to_owned(), model_slug.to_owned())
            .await?;

        let response = model::get::GetModelResponse {
            model,
            associations,
            attributes,
        };

        Ok(response)
    }
}

#[async_trait::async_trait]
impl model::get_class_diagram::GetModel for Repo {
    async fn get_model(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<model::get_class_diagram::GetModelResponse> {
        let (model, associations, attributes) = self
            .get_model_full(project_slug.to_owned(), model_slug.to_owned())
            .await?;

        let response = model::get_class_diagram::GetModelResponse {
            model,
            associations,
            attributes,
        };

        Ok(response)
    }
}

#[async_trait::async_trait]
impl model::get_project_class_diagram::ListModels for Repo {
    async fn list_models(
        &self,
        project_slug: &str,
    ) -> FoundationResult<model::get_project_class_diagram::ListModelsResponse> {
        let model_records = self.list_models(project_slug.to_owned()).await?;

        let mut models = Vec::with_capacity(model_records.len());

        for model_record in model_records {
            let (model, associations, attributes) = self
                .get_model_full(project_slug.to_owned(), model_record.slug)
                .await?;

            models.push(model::get_project_class_diagram::ModelData {
                model,
                associations,
                attributes,
            })
        }

        let response = model::get_project_class_diagram::ListModelsResponse { models };

        Ok(response)
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

    async fn get_model(
        &self,
        project_slug: String,
        model_slug: String,
    ) -> PortalResult<datastore::model::Model> {
        let mut client = self.connect().await?;

        let response = client
            .get_model_record(proto::GetModelRecordRequest {
                project_slug,
                model_slug,
                ..proto::GetModelRecordRequest::default()
            })
            .await?
            .into_inner();

        let proto_model = response
            .model_record
            .ok_or(PortalError::internal("empty model_record"))?;

        let model = from_proto_model(proto_model)?;

        Ok(model)
    }

    async fn get_model_full(
        &self,
        project_slug: String,
        model_slug: String,
    ) -> PortalResult<(
        datastore::model::Model,
        Vec<datastore::model::Association>,
        Vec<datastore::model::Attribute>,
    )> {
        let mut client = self.connect().await?;

        let response = client
            .get_model_record(proto::GetModelRecordRequest {
                project_slug,
                model_slug,
                preload_attributes: true,
                preload_associations: true,
            })
            .await?
            .into_inner();

        let proto_model = response
            .model_record
            .ok_or(PortalError::internal("empty model_record"))?;

        let model = from_proto_model(proto_model)?;
        let associations = response
            .model_association_records
            .into_iter()
            .map(from_proto_model_association)
            .collect::<PortalResult<Vec<datastore::model::Association>>>()?;

        let attributes = response
            .model_attribute_records
            .into_iter()
            .map(from_proto_model_attribute)
            .collect::<PortalResult<Vec<datastore::model::Attribute>>>()?;

        Ok((model, associations, attributes))
    }

    async fn list_models(
        &self,
        project_slug: String,
    ) -> PortalResult<Vec<datastore::model::Model>> {
        let mut client = self.connect().await?;

        let response = client
            .list_model_records(proto::ListModelRecordsRequest { project_slug })
            .await?
            .into_inner();

        let models = response
            .model_records
            .into_iter()
            .map(from_proto_model)
            .collect::<PortalResult<Vec<datastore::model::Model>>>()?;

        Ok(models)
    }

    async fn create_model(
        &self,
        project_record: datastore::project::Project,
        model: model::Model,
    ) -> PortalResult<datastore::model::Model> {
        let mut client = self.connect().await?;

        let response = client
            .create_model_record(proto::CreateModelRecordRequest {
                project_id: project_record.id.to_string(),
                description: model.description.unwrap_or_default(),
                name: model.name,
                slug: model.slug,
            })
            .await?
            .into_inner();

        let proto_model = response
            .model_record
            .ok_or(PortalError::internal("empty model_record"))?;

        let model = from_proto_model(proto_model)?;

        Ok(model)
    }

    async fn delete_model(&self, model: datastore::model::Model) -> PortalResult<()> {
        let mut client = self.connect().await?;

        client
            .delete_model_record(proto::DeleteModelRecordRequest {
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
        let mut client = self.connect().await?;

        let response = client
            .create_model_attribute_record(proto::CreateModelAttributeRecordRequest {
                model_id: model_record.id.to_string(),
                description: model_attribute.description.unwrap_or_default(),
                name: model_attribute.name,
                kind: match model_attribute.kind {
                    model::AttributeKind::String => proto::dimensions::ModelAttributeKind::String,
                    model::AttributeKind::Int64 => proto::dimensions::ModelAttributeKind::Int64,
                    model::AttributeKind::Bool => proto::dimensions::ModelAttributeKind::Bool,
                }
                .into(),
            })
            .await?
            .into_inner();

        let proto_model_attribute = response
            .model_attribute_record
            .ok_or(PortalError::internal("empty model_attribute_record"))?;

        let model = from_proto_model_attribute(proto_model_attribute)?;

        Ok(model)
    }

    async fn get_model_attribute(
        &self,
        project_slug: String,
        model_slug: String,
        attribute_name: String,
    ) -> PortalResult<datastore::model::Attribute> {
        let mut client = self.connect().await?;

        let response = client
            .get_model_attribute_record(proto::GetModelAttributeRecordRequest {
                project_slug,
                model_slug,
                attribute_name,
            })
            .await?
            .into_inner();

        let proto_model_attribute = response
            .model_attribute_record
            .ok_or(PortalError::internal("empty model_record"))?;

        let model_attribute = from_proto_model_attribute(proto_model_attribute)?;

        Ok(model_attribute)
    }

    async fn delete_model_attribute(
        &self,
        model_attribute: datastore::model::Attribute,
    ) -> PortalResult<()> {
        let mut client = self.connect().await?;

        client
            .delete_model_attribute_record(proto::DeleteModelAttributeRecordRequest {
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
        let mut client = self.connect().await?;

        let response = client
            .create_model_association_record(proto::CreateModelAssociationRecordRequest {
                model_id: model_record.id.to_string(),
                associated_model_id: associated_model_record.id.to_string(),
                description: model_association.description.unwrap_or_default(),
                name: model_association.name,
                kind: match model_association.kind {
                    model::AssociationKind::HasMany => {
                        proto::dimensions::ModelAssociationKind::HasMany
                    }
                    model::AssociationKind::HasOne => {
                        proto::dimensions::ModelAssociationKind::HasOne
                    }
                    model::AssociationKind::BelongsTo => {
                        proto::dimensions::ModelAssociationKind::BelongsTo
                    }
                }
                .into(),
            })
            .await?
            .into_inner();

        let proto_model_association = response
            .model_association_record
            .ok_or(PortalError::internal("empty model_association_record"))?;

        let model_association = from_proto_model_association(proto_model_association)?;

        Ok(model_association)
    }

    async fn get_model_association(
        &self,
        project_slug: String,
        model_slug: String,
        association_name: String,
    ) -> PortalResult<datastore::model::Association> {
        let mut client = self.connect().await?;

        let response = client
            .get_model_association_record(proto::GetModelAssociationRecordRequest {
                project_slug,
                model_slug,
                association_name,
            })
            .await?
            .into_inner();

        let proto_model_association = response
            .model_association_record
            .ok_or(PortalError::internal("empty model_record"))?;

        let model_attribute = from_proto_model_association(proto_model_association)?;

        Ok(model_attribute)
    }

    async fn delete_model_association(
        &self,
        model_association: datastore::model::Association,
    ) -> PortalResult<()> {
        let mut client = self.connect().await?;

        client
            .delete_model_association_record(proto::DeleteModelAssociationRecordRequest {
                id: model_association.id.to_string(),
            })
            .await?;

        Ok(())
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

fn from_proto_model(
    proto_model: proto::dimensions::Model,
) -> PortalResult<datastore::model::Model> {
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

fn from_proto_model_attribute(
    proto_model_attribute: proto::dimensions::ModelAttribute,
) -> PortalResult<datastore::model::Attribute> {
    use proto::dimensions::ModelAttributeKind::*;

    let create_time = proto_model_attribute
        .create_time
        .ok_or(PortalError::internal("missing #create_time for Model"))?;

    let update_time = proto_model_attribute
        .update_time
        .ok_or(PortalError::internal("missing #update_time for Model"))?;

    let proto_model_attribute_kind =
        proto::dimensions::ModelAttributeKind::from_i32(proto_model_attribute.kind)
            .ok_or(PortalError::internal("missing #kind for ModelAttribute"))?;

    let model_attribute = datastore::model::Attribute {
        id: util::proto::uuid_from_proto_string(&proto_model_attribute.id, "id")?,
        model_id: util::proto::uuid_from_proto_string(&proto_model_attribute.model_id, "model_id")?,
        description: proto_model_attribute.description,
        kind: match proto_model_attribute_kind {
            UnspecifiedAttributeKind => {
                return Err(PortalError::internal("UnspecifiedAttributeKind"))
            }
            String => datastore::model::AttributeKind::String,
            Int64 => datastore::model::AttributeKind::Int64,
            Bool => datastore::model::AttributeKind::Bool,
        },
        name: proto_model_attribute.name,
        inserted_at: util::proto::from_proto_timestamp(create_time, "insert_time")?,
        updated_at: util::proto::from_proto_timestamp(update_time, "update_time")?,
    };

    Ok(model_attribute)
}

fn from_proto_model_association(
    proto_model_association: proto::dimensions::ModelAssociation,
) -> PortalResult<datastore::model::Association> {
    use proto::dimensions::ModelAssociationKind::*;

    let create_time = proto_model_association
        .create_time
        .ok_or(PortalError::internal("missing #create_time for Model"))?;

    let update_time = proto_model_association
        .update_time
        .ok_or(PortalError::internal("missing #update_time for Model"))?;

    let proto_model_association_kind =
        proto::dimensions::ModelAssociationKind::from_i32(proto_model_association.kind)
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
        associated_model: from_proto_model(associated_model)?,
        description: proto_model_association.description,
        kind: match proto_model_association_kind {
            UnspecifiedAssociationKind => {
                return Err(PortalError::internal("UnspecifiedAttributeKind"))
            }
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
