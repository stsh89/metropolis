require Rails.root.join("lib/proto/temple/v1/attribute_types_pb").to_s
require Rails.root.join("lib/proto/temple/v1/attribute_types_services_pb.rb").to_s
require "google/protobuf/well_known_types"

# API definitions around attribute types.
class AttributeTypesApi
  include Singleton

  def initialize
    @client = initialize_client
  end

  # Request API to create new attribute type
  #
  # @param attribute_type [AttributeType]
  # @return [AttributeType] new attribute type with generated slug
  def create_attribute_type(attribute_type)
    response = @client.create_attribute_type(attribute_type)
    to_model(response)
  end

  # Request API to list attribute types.
  #
  # @return [Array<AttributeType>]
  def list_attribute_types
    response = @client.list_attribute_types
    to_model_list(response.attribute_types)
  end

  # Request API to get single attribute type.
  #
  # @param id [String] slug of the attribute type
  # @return [AttributeType]
  def get_attribute_type(id)
    response = @client.get_attribute_type(id)
    to_model(response)
  end

  # Request API to update attribute type.
  #
  # @param attribute_type [AttributeType]
  # @return [AttributeType] with the updated values
  def update_attribute_type(attribute_type)
    response = @client.update_attribute_type(attribute_type)
    to_model(response)
  end

  # Request API to delete attribute type.
  #
  # @param attribute_type [AttributeType] to delete
  # @return nil
  def delete_attribute_type(attribute_type)
    _response = @client.delete_attribute_type(attribute_type)
    nil
  end

  # Remove all attribute types. Used for testing purposed only.
  def delete_all_attribute_types
    @client.delete_all_attribute_types
  end

  private

  def initialize_client
    {
      in_memory: InMemoryAttributeTypesApiClient,
    }
      .fetch(Theater::Application.config.api_interaction_kind)
      .new
  end

  def to_model(proto)
    AttributeTypeApiConverter.to_model(proto)
  end

  def to_model_list(protos)
    protos.map { |proto| to_model(proto) }
  end
end
