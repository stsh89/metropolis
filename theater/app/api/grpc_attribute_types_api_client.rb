require Rails.root.join("lib/proto/temple/v1/attribute_types/attribute_types_pb").to_s
require Rails.root.join("lib/proto/temple/v1/attribute_types/attribute_types_services_pb").to_s
require "google/protobuf/well_known_types"

class GrpcAttributeTypesApiClient
  def initialize
    @stub = Proto::Temple::V1::AttributeTypes::AttributeTypes::Stub
      .new(TheaterConfig.projects_client.socket_address, :this_channel_is_insecure)
  end

  def create_attribute_type(attribute_type)
    @stub.create_attribute_type(Proto::Temple::V1::AttributeTypes::CreateAttributeTypeRequest.new(
      name: attribute_type.name,
      description: attribute_type.description,
    ))
  end

  def list_attribute_types
    @stub.list_attribute_types(Proto::Temple::V1::AttributeTypes::ListAttributeTypesRequest.new)
  end

  def get_attribute_type(id)
    @stub.get_attribute_type(Proto::Temple::V1::AttributeTypes::GetAttributeTypeRequest.new(
      slug: id,
    ))
  end

  def update_attribute_type(attribute_type)
    @stub.update_attribute_type(Proto::Temple::V1::AttributeTypes::UpdateAttributeTypeRequest.new(
      attribute_type: from_model(attribute_type),
      update_mask: Google::Protobuf::FieldMask.new({ paths: %w[description name] }),
    ))
  end

  def delete_attribute_type(attribute_type)
    @stub.delete_attribute_type(Proto::Temple::V1::AttributeTypes::DeleteAttributeTypeRequest.new(
      slug: attribute_type.slug,
    ))
  end

  private

  def from_model(attribute_type)
    AttributeTypeApiConverter.from_model(attribute_type)
  end
end
