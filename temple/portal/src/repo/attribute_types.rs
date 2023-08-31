use super::map_status_error;
use crate::util;
use foundation::{
    attribute_type::{
        AttributeType, AttributeTypeRecord, CreateAttributeTypeRecord, DeleteAttributeTypeRecord,
        GetAttributeTypeRecord, ListAttributeTypeRecords, UpdateAttributeTypeRecord,
    },
    FoundationError, FoundationResult,
};
use prost_types::FieldMask;

mod rpc {
    tonic::include_proto!("proto.gymnasium.v1.attribute_types");
}

pub struct AttributeTypesRepo {
    pub connection_string: String,
}

#[async_trait::async_trait]
impl ListAttributeTypeRecords for AttributeTypesRepo {
    async fn list_attribute_type_records(&self) -> FoundationResult<Vec<AttributeTypeRecord>> {
        let mut client = self.client().await?;

        let response = client
            .list_attribute_types(rpc::ListAttributeTypesRequest {})
            .await
            .map_err(map_status_error)?
            .into_inner();

        let attribute_type_records = response
            .attribute_types
            .into_iter()
            .map(record_from_proto)
            .collect::<FoundationResult<Vec<AttributeTypeRecord>>>()?;

        Ok(attribute_type_records)
    }
}

#[async_trait::async_trait]
impl GetAttributeTypeRecord for AttributeTypesRepo {
    async fn get_attribute_type_record(
        &self,
        slug: &str,
    ) -> FoundationResult<Option<AttributeTypeRecord>> {
        let mut client = self.client().await?;

        let proto_attribute_type = client
            .find_attribute_type(rpc::FindAttributeTypeRequest {
                slug: slug.to_owned(),
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let attribute_type_record = record_from_proto(proto_attribute_type)?;

        Ok(Some(attribute_type_record))
    }
}

#[async_trait::async_trait]
impl CreateAttributeTypeRecord for AttributeTypesRepo {
    async fn create_attribute_type_record(
        &self,
        attribute_type: AttributeType,
    ) -> FoundationResult<AttributeTypeRecord> {
        let mut client = self.client().await?;

        let AttributeType {
            description,
            name,
            slug,
        } = attribute_type;

        let proto_attribute_type = client
            .create_attribute_type(rpc::CreateAttributeTypeRequest {
                description: description.unwrap_or_default(),
                name,
                slug,
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let attribute_type_record = record_from_proto(proto_attribute_type)?;

        Ok(attribute_type_record)
    }
}

#[async_trait::async_trait]
impl UpdateAttributeTypeRecord for AttributeTypesRepo {
    async fn update_attribute_type_record(
        &self,
        attribute_type_record: AttributeTypeRecord,
    ) -> FoundationResult<AttributeTypeRecord> {
        let mut client = self.client().await?;

        let AttributeTypeRecord {
            id,
            inner:
                AttributeType {
                    description,
                    name,
                    slug,
                },
            ..
        } = attribute_type_record;

        let proto_attribute_type = client
            .update_attribute_type(rpc::UpdateAttributeTypeRequest {
                attribute_type: Some(rpc::AttributeType {
                    id: id.to_string(),
                    name,
                    description: description.unwrap_or_default(),
                    slug,
                    create_time: None,
                    update_time: None,
                }),
                update_mask: Some(FieldMask {
                    paths: vec![
                        "name".to_string(),
                        "description".to_string(),
                        "slug".to_string(),
                    ],
                }),
            })
            .await
            .map_err(map_status_error)?
            .into_inner();

        let attribute_type_record = record_from_proto(proto_attribute_type)?;

        Ok(attribute_type_record)
    }
}

#[async_trait::async_trait]
impl DeleteAttributeTypeRecord for AttributeTypesRepo {
    async fn delete_attribute_type_record(
        &self,
        attribute_type: AttributeTypeRecord,
    ) -> FoundationResult<()> {
        let mut client = self.client().await?;

        let AttributeTypeRecord { id, .. } = attribute_type;

        client
            .delete_attribute_type(rpc::DeleteAttributeTypeRequest { id: id.to_string() })
            .await
            .map_err(map_status_error)?;

        Ok(())
    }
}

impl AttributeTypesRepo {
    async fn client(
        &self,
    ) -> FoundationResult<
        rpc::attribute_types_client::AttributeTypesClient<tonic::transport::Channel>,
    > {
        rpc::attribute_types_client::AttributeTypesClient::connect(self.connection_string.clone())
            .await
            .map_err(|err| FoundationError::internal(err.to_string()))
    }
}

fn record_from_proto(
    proto_attribute_type: rpc::AttributeType,
) -> FoundationResult<AttributeTypeRecord> {
    let create_time = proto_attribute_type
        .create_time
        .ok_or(FoundationError::internal(
            "missing #create_time for attribute type",
        ))?;

    let update_time = proto_attribute_type
        .update_time
        .ok_or(FoundationError::internal(
            "missing #update_time for attribute type",
        ))?;

    let record = AttributeTypeRecord {
        id: util::proto::uuid_from_proto_string(&proto_attribute_type.id, "id")
            .map_err(map_status_error)?,
        inner: AttributeType {
            description: Some(proto_attribute_type.description),
            name: proto_attribute_type.name,
            slug: proto_attribute_type.slug,
        },
        inserted_at: util::proto::from_proto_timestamp(create_time, "insert_time")
            .map_err(map_status_error)?,
        updated_at: util::proto::from_proto_timestamp(update_time, "update_time")
            .map_err(map_status_error)?,
    };

    Ok(record)
}
