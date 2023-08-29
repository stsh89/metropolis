class GrpcAttributeTypesApiClient
  def initialize
    @stub = Proto::Temple::V1::AttributeTypes::Stub
      .new(TheaterConfig.projects_client.socket_address, :this_channel_is_insecure)
  end

  def create_attribute_type(attribute_type)
    @stub.create_project(Proto::Temple::V1::CreateAttributeTypeRequest.new(
      name: attribute_type.name,
      description: attribute_type.description,
    ))
  end

  def list_attribute_types
    @stub.list_attribute_types(Proto::Temple::V1::ListAttributeTypes.new)
  end

  def get_attribute_type(id)
    @stub.get_attribute_type(Proto::Temple::V1::GetAttributeTypeRequest.new(
      slug: id,
    ))
  end

  def update_attribute_type(attribute_type)
    @stub.update_attribute_type(Proto::Temple::V1::UpdateAttributeTypeRequest.new(
      attibute_type: from_model(attribute_type),
      update_mask: %w[name description],
    ))
  end

  def delete_attribute_type(attribute_type)
    @stub.delete_attribute_type(Proto::Temple::V1::DeleteAttributeTypeRequest.new(
      slug: attribute_type.slug,
    ))
  end

  private

  def from_model(attribute_type)
    AttributeTypeApiConverter.from_model(attribute_type)
  end
end
