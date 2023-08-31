pub mod rpc {
    tonic::include_proto!("proto.temple.v1.attribute_types"); // The string specified here must match the proto package name
}

pub struct AttributeTypesServer {}

#[tonic::async_trait]
impl rpc::attribute_types_server::AttributeTypes for AttributeTypesServer {
    async fn create_attribute_type(
        &self,
        request: tonic::Request<rpc::CreateAttributeTypeRequest>,
    ) -> std::result::Result<tonic::Response<rpc::AttributeType>, tonic::Status> {
        println!("Got a request: {:?}", request);

        Err(tonic::Status::unimplemented(""))
    }

    async fn get_attribute_type(
        &self,
        request: tonic::Request<rpc::GetAttributeTypeRequest>,
    ) -> std::result::Result<tonic::Response<rpc::AttributeType>, tonic::Status> {
        println!("Got a request: {:?}", request);

        Err(tonic::Status::unimplemented(""))
    }

    async fn list_attribute_types(
        &self,
        request: tonic::Request<rpc::ListAttributeTypesRequest>,
    ) -> std::result::Result<tonic::Response<rpc::ListAttributeTypesResponse>, tonic::Status> {
        println!("Got a request: {:?}", request);

        Err(tonic::Status::unimplemented(""))
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

        Err(tonic::Status::unimplemented(""))
    }
}
