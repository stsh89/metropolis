use super::map_status_error;
use crate::util;
use foundation::{
    datastore,
    model::{
        Association, AssociationKind, Attribute, AttributeKind, CreateModelAssociationRecord,
        CreateModelAttributeRecord, CreateModelRecord, DeleteModelAssociationRecord,
        DeleteModelAttributeRecord, DeleteModelRecord, GetModelAssociationRecord,
        GetModelAttributeRecord, GetModelOverviewRecord, GetModelRecord, ListModelOverviewRecords,
        ListModelRecords, Model,
    },
    FoundationError, FoundationResult,
};

pub mod rpc {
    tonic::include_proto!("proto.gymnasium.v1.models");
}

pub struct ModelsRepo {
    pub connection_string: String,
}

#[async_trait::async_trait]
impl CreateModelRecord for ModelsRepo {
    async fn create_model_record(
        &self,
        project_record: datastore::project::Project,
        model: Model,
    ) -> FoundationResult<datastore::model::Model> {
        let mut client = self.client().await?;

        let proto_model = client
            .create_model(rpc::CreateModelRequest {
                project_id: project_record.id.to_string(),
                description: model.description.unwrap_or_default(),
                name: model.name,
                slug: model.slug,
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let model = datastore_model(proto_model)?;

        Ok(model)
    }
}

#[async_trait::async_trait]
impl GetModelOverviewRecord for ModelsRepo {
    async fn get_model_overview_record(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::ModelOverview> {
        let mut client = self.client().await?;

        let proto_model_overview = client
            .find_project_model_overview(rpc::FindProjectModelOverviewRequest {
                project_slug: project_slug.to_owned(),
                model_slug: model_slug.to_owned(),
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let model_overview = datastore_model_overview(proto_model_overview)?;

        Ok(model_overview)
    }
}

#[async_trait::async_trait]
impl ListModelRecords for ModelsRepo {
    async fn list_model_records(
        &self,
        project_slug: &str,
    ) -> FoundationResult<Vec<datastore::model::Model>> {
        let mut client = self.client().await?;

        let response = client
            .list_project_models(rpc::ListProjectModelsRequest {
                project_slug: project_slug.to_owned(),
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let models = response
            .models
            .into_iter()
            .map(datastore_model)
            .collect::<FoundationResult<Vec<datastore::model::Model>>>()?;

        Ok(models)
    }
}

#[async_trait::async_trait]
impl ListModelOverviewRecords for ModelsRepo {
    async fn list_model_overview_records(
        &self,
        project_slug: &str,
    ) -> FoundationResult<Vec<datastore::model::ModelOverview>> {
        let mut client = self.client().await?;

        let model_overviews = client
            .list_project_model_overviews(rpc::ListProjectModelOverviewsRequest {
                project_slug: project_slug.to_owned(),
            })
            .await
            .map_err(map_status_error)?
            .into_inner()
            .model_overviews
            .into_iter()
            .map(datastore_model_overview)
            .collect::<FoundationResult<Vec<datastore::model::ModelOverview>>>()?;

        Ok(model_overviews)
    }
}

#[async_trait::async_trait]
impl DeleteModelRecord for ModelsRepo {
    async fn delete_model_record(&self, model: datastore::model::Model) -> FoundationResult<()> {
        let mut client = self.client().await?;

        client
            .delete_model(rpc::DeleteModelRequest {
                id: model.id.to_string(),
            })
            .await
            .map_err(map_status_error)?;

        Ok(())
    }
}

#[async_trait::async_trait]
impl GetModelRecord for ModelsRepo {
    async fn get_model_record(
        &self,
        project_slug: &str,
        model_slug: &str,
    ) -> FoundationResult<datastore::model::Model> {
        let mut client = self.client().await?;

        let proto_model = client
            .find_project_model(rpc::FindProjectModelRequest {
                project_slug: project_slug.to_owned(),
                model_slug: model_slug.to_owned(),
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let model = datastore_model(proto_model)?;

        Ok(model)
    }
}

#[async_trait::async_trait]
impl GetModelAttributeRecord for ModelsRepo {
    async fn get_model_attribute_record(
        &self,
        project_slug: &str,
        model_slug: &str,
        attribute_name: &str,
    ) -> FoundationResult<datastore::model::Attribute> {
        let mut client = self.client().await?;

        let proto_model_attribute = client
            .find_project_model_attribute(rpc::FindProjectModelAttributeRequest {
                project_slug: project_slug.to_owned(),
                model_slug: model_slug.to_owned(),
                attribute_name: attribute_name.to_owned(),
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let attribute = datastore_model_attribute(proto_model_attribute)?;

        Ok(attribute)
    }
}

#[async_trait::async_trait]
impl DeleteModelAttributeRecord for ModelsRepo {
    async fn delete_model_attribute_record(
        &self,
        model_attribute: datastore::model::Attribute,
    ) -> FoundationResult<()> {
        let mut client = self.client().await?;

        client
            .delete_attribute(rpc::DeleteAttributeRequest {
                id: model_attribute.id.to_string(),
            })
            .await
            .map_err(map_status_error)?;

        Ok(())
    }
}

#[async_trait::async_trait]
impl GetModelAssociationRecord for ModelsRepo {
    async fn get_model_association_record(
        &self,
        project_slug: &str,
        model_slug: &str,
        association_name: &str,
    ) -> FoundationResult<datastore::model::Association> {
        let mut client = self.client().await?;

        let proto_model_association = client
            .find_project_model_association(rpc::FindProjectModelAssociationRequest {
                project_slug: project_slug.to_owned(),
                model_slug: model_slug.to_owned(),
                association_name: association_name.to_owned(),
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let association = datastore_model_association(proto_model_association)?;

        Ok(association)
    }
}

#[async_trait::async_trait]
impl DeleteModelAssociationRecord for ModelsRepo {
    async fn delete_model_association_record(
        &self,
        model_association: datastore::model::Association,
    ) -> FoundationResult<()> {
        let mut client = self.client().await?;

        client
            .delete_association(rpc::DeleteAssociationRequest {
                id: model_association.id.to_string(),
            })
            .await
            .map_err(map_status_error)?;

        Ok(())
    }
}

#[async_trait::async_trait]
impl CreateModelAttributeRecord for ModelsRepo {
    async fn create_model_attribute_record(
        &self,
        model_record: datastore::model::Model,
        attribute: Attribute,
    ) -> FoundationResult<datastore::model::Attribute> {
        let mut client = self.client().await?;

        let proto_attribute = client
            .create_attribute(rpc::CreateAttributeRequest {
                model_id: model_record.id.to_string(),
                description: attribute.description.unwrap_or_default(),
                name: attribute.name,
                kind: match attribute.kind {
                    AttributeKind::String => rpc::AttributeKind::String,
                    AttributeKind::Integer => rpc::AttributeKind::Integer,
                    AttributeKind::Boolean => rpc::AttributeKind::Boolean,
                }
                .into(),
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let attribute = datastore_model_attribute(proto_attribute)?;

        Ok(attribute)
    }
}

#[async_trait::async_trait]
impl CreateModelAssociationRecord for ModelsRepo {
    async fn create_model_association_record(
        &self,
        model_record: datastore::model::Model,
        associated_model_record: datastore::model::Model,
        association: Association,
    ) -> FoundationResult<datastore::model::Association> {
        let mut client = self.client().await?;

        let proto_model_association = client
            .create_association(rpc::CreateAssociationRequest {
                model_id: model_record.id.to_string(),
                associated_model_id: associated_model_record.id.to_string(),
                description: association.description.unwrap_or_default(),
                name: association.name,
                kind: match association.kind {
                    AssociationKind::HasMany => rpc::AssociationKind::HasMany,
                    AssociationKind::HasOne => rpc::AssociationKind::HasOne,
                    AssociationKind::BelongsTo => rpc::AssociationKind::BelongsTo,
                }
                .into(),
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let association = datastore_model_association(proto_model_association)?;

        Ok(association)
    }
}

fn datastore_model(proto_model: rpc::Model) -> FoundationResult<datastore::model::Model> {
    let create_time = proto_model
        .create_time
        .ok_or(FoundationError::internal("missing #create_time for Model"))?;

    let update_time = proto_model
        .update_time
        .ok_or(FoundationError::internal("missing #update_time for Model"))?;

    let model = datastore::model::Model {
        id: util::proto::uuid_from_proto_string(&proto_model.id, "id").map_err(map_status_error)?,
        project_id: util::proto::uuid_from_proto_string(&proto_model.project_id, "project_id")
            .map_err(map_status_error)?,
        description: proto_model.description,
        name: proto_model.name,
        slug: proto_model.slug,
        inserted_at: util::proto::from_proto_timestamp(create_time, "insert_time")
            .map_err(map_status_error)?,
        updated_at: util::proto::from_proto_timestamp(update_time, "update_time")
            .map_err(map_status_error)?,
    };

    Ok(model)
}

impl ModelsRepo {
    async fn client(
        &self,
    ) -> FoundationResult<rpc::models_client::ModelsClient<tonic::transport::Channel>> {
        rpc::models_client::ModelsClient::connect(self.connection_string.clone())
            .await
            .map_err(|err| FoundationError::internal(err.to_string()))
    }
}

fn datastore_model_attribute(
    proto_model_attribute: rpc::Attribute,
) -> FoundationResult<datastore::model::Attribute> {
    use rpc::AttributeKind;

    let create_time = proto_model_attribute
        .create_time
        .ok_or(FoundationError::internal("missing #create_time for Model"))?;

    let update_time = proto_model_attribute
        .update_time
        .ok_or(FoundationError::internal("missing #update_time for Model"))?;

    let proto_model_attribute_kind = rpc::AttributeKind::from_i32(proto_model_attribute.kind)
        .ok_or(FoundationError::internal(
            "missing #kind for ModelAttribute",
        ))?;

    let model_attribute = datastore::model::Attribute {
        id: util::proto::uuid_from_proto_string(&proto_model_attribute.id, "id")
            .map_err(map_status_error)?,
        model_id: util::proto::uuid_from_proto_string(&proto_model_attribute.model_id, "model_id")
            .map_err(map_status_error)?,
        description: proto_model_attribute.description,
        kind: match proto_model_attribute_kind {
            AttributeKind::Unspecified => {
                return Err(FoundationError::internal("UnspecifiedAttributeKind"))
            }
            AttributeKind::String => datastore::model::AttributeKind::String,
            AttributeKind::Integer => datastore::model::AttributeKind::Integer,
            AttributeKind::Boolean => datastore::model::AttributeKind::Boolean,
        },
        name: proto_model_attribute.name,
        inserted_at: util::proto::from_proto_timestamp(create_time, "insert_time")
            .map_err(map_status_error)?,
        updated_at: util::proto::from_proto_timestamp(update_time, "update_time")
            .map_err(map_status_error)?,
    };

    Ok(model_attribute)
}

pub fn datastore_model_association(
    proto_model_association: rpc::Association,
) -> FoundationResult<datastore::model::Association> {
    use rpc::AssociationKind::*;

    let create_time = proto_model_association
        .create_time
        .ok_or(FoundationError::internal("missing #create_time for Model"))?;

    let update_time = proto_model_association
        .update_time
        .ok_or(FoundationError::internal("missing #update_time for Model"))?;

    let proto_model_association_kind = rpc::AssociationKind::from_i32(proto_model_association.kind)
        .ok_or(FoundationError::internal(
            "missing #kind for ModelAttribute",
        ))?;

    let associated_model =
        proto_model_association
            .associated_model
            .ok_or(FoundationError::internal(
                "missing #associated_model for ModelAssociation",
            ))?;

    let model_attribute = datastore::model::Association {
        id: util::proto::uuid_from_proto_string(&proto_model_association.id, "id")
            .map_err(map_status_error)?,
        model_id: util::proto::uuid_from_proto_string(
            &proto_model_association.model_id,
            "model_id",
        )
        .map_err(map_status_error)?,
        associated_model: datastore_model(associated_model)?,
        description: proto_model_association.description,
        kind: match proto_model_association_kind {
            Unspecified => return Err(FoundationError::internal("UnspecifiedAttributeKind")),
            BelongsTo => datastore::model::AssociationKind::BelongsTo,
            HasOne => datastore::model::AssociationKind::HasOne,
            HasMany => datastore::model::AssociationKind::HasMany,
        },
        name: proto_model_association.name,
        inserted_at: util::proto::from_proto_timestamp(create_time, "insert_time")
            .map_err(map_status_error)?,
        updated_at: util::proto::from_proto_timestamp(update_time, "update_time")
            .map_err(map_status_error)?,
    };

    Ok(model_attribute)
}

fn datastore_model_overview(
    proto_model_overview: rpc::ModelOverview,
) -> FoundationResult<datastore::model::ModelOverview> {
    Ok(datastore::model::ModelOverview {
        model: proto_model_overview
            .model
            .map(datastore_model)
            .transpose()?
            .ok_or(FoundationError::internal(
                "missing #model field".to_string(),
            ))?,
        associations: proto_model_overview
            .associations
            .into_iter()
            .map(datastore_model_association)
            .collect::<FoundationResult<Vec<datastore::model::Association>>>()?,
        attributes: proto_model_overview
            .attributes
            .into_iter()
            .map(datastore_model_attribute)
            .collect::<FoundationResult<Vec<datastore::model::Attribute>>>()?,
    })
}
