use crate::repo::AttributeTypesRepo;
use crate::PortalError;
use foundation::attribute_type::{self, AttributeType};
use tonic::Response;

pub mod rpc {
    tonic::include_proto!("proto.temple.v1.attribute_types"); // The string specified here must match the proto package name
}

pub struct AttributeTypesServer {
    pub attribute_types_repo: AttributeTypesRepo,
}

#[tonic::async_trait]
impl rpc::attribute_types_server::AttributeTypes for AttributeTypesServer {
    async fn create_attribute_type(
        &self,
        request: tonic::Request<rpc::CreateAttributeTypeRequest>,
    ) -> std::result::Result<tonic::Response<rpc::AttributeType>, tonic::Status> {
        println!("Got a request: {:?}", request);

        let rpc::CreateAttributeTypeRequest { description, name } = request.into_inner();

        let attribute_type = attribute_type::create(&self.attribute_types_repo, attribute_type::CreateRequest {
            description,
            name
        })
            .await
            .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(to_proto_attribute_type(attribute_type)))
    }

    async fn get_attribute_type(
        &self,
        request: tonic::Request<rpc::GetAttributeTypeRequest>,
    ) -> std::result::Result<tonic::Response<rpc::AttributeType>, tonic::Status> {
        println!("Got a request: {:?}", request);

        let rpc::GetAttributeTypeRequest { slug } = request.into_inner();

        let attribute_type = attribute_type::get(&self.attribute_types_repo, &slug)
            .await
            .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(to_proto_attribute_type(attribute_type)))
    }

    async fn list_attribute_types(
        &self,
        request: tonic::Request<rpc::ListAttributeTypesRequest>,
    ) -> std::result::Result<tonic::Response<rpc::ListAttributeTypesResponse>, tonic::Status> {
        println!("Got a request: {:?}", request);

        let attribute_types: Vec<rpc::AttributeType> =
            attribute_type::list(&self.attribute_types_repo)
                .await
                .map_err(Into::<PortalError>::into)?
                .into_iter()
                .map(to_proto_attribute_type)
                .collect();

        Ok(Response::new(rpc::ListAttributeTypesResponse {
            attribute_types,
        }))
    }

    async fn update_attribute_type(
        &self,
        request: tonic::Request<rpc::UpdateAttributeTypeRequest>,
    ) -> std::result::Result<tonic::Response<rpc::AttributeType>, tonic::Status> {
        println!("Got a request: {:?}", request);

        Err(tonic::Status::unimplemented(""))
    }

    async fn delete_attribute_type(
        &self,
        request: tonic::Request<rpc::DeleteAttributeTypeRequest>,
    ) -> std::result::Result<tonic::Response<()>, tonic::Status> {
        println!("Got a request: {:?}", request);

        let rpc::DeleteAttributeTypeRequest { slug } = request.into_inner();

        attribute_type::delete(&self.attribute_types_repo, &slug)
            .await
            .map_err(Into::<PortalError>::into)?;

        Ok(Response::new(()))
    }
}

fn to_proto_attribute_type(attto_proto_attribute_type: AttributeType) -> rpc::AttributeType {
    rpc::AttributeType {
        description: attto_proto_attribute_type.description.unwrap_or_default(),
        name: attto_proto_attribute_type.name,
        slug: attto_proto_attribute_type.slug,
    }
}
