require "#{Rails.root}/lib/proto/temple/v1/attribute_types_pb"
require "#{Rails.root}/lib/proto/temple/v1/attribute_types_services_pb.rb"
require 'google/protobuf/well_known_types'

class AttributeTypesApi
  include Singleton

  def initialize
    @client = initialize_client
  end

  def create_attribute_type(attribute_type)
    @client.create_attribute_type(attribute_type)
  end

  def list_attribute_types
    @client.list_attribute_types
  end

  def get_attribute_type(id)
    @client.get_attribute_type(id)
  end

  def update_attribute_type(attribute_type)
    @client.update_attribute_type(attribute_type)
  end

  def delete_attribute_type(attribute_type)
    @client.delete_attribute_type(attribute_type)
  end

  def delete_all_attribute_types
    @client.delete_all_attribute_types
  end

  private

  def initialize_client
    case Theater::Application.config.api_interaction_kind
    when :in_memory
      InMemoryAttributeTypesApi.new
    else
      raise StandardError.new('Misconfigured API interaction kind')
    end
  end

  class InMemoryAttributeTypesApi
    def initialize
      @attribute_types = []
    end

    def create_attribute_type(attribute_type)
      proto_attribute_type = Proto::Temple::V1::AttributeType.new(
        description: attribute_type.description,
        name: attribute_type.name,
        slug: attribute_type.name.downcase
      )

      @attribute_types.push(proto_attribute_type)
      @attribute_types.sort_by!{ |at| at.name }

      proto_attribute_type
    end

    def list_attribute_types
      Proto::Temple::V1::ListAttributeTypesResponse.new(
        attribute_types: @attribute_types
      )
    end

    def get_attribute_type(id)
      @attribute_types.find { |at| at.slug == id }
    end

    def update_attribute_type(attribute_type)
      proto_attribute_type = Proto::Temple::V1::AttributeType.new(
        description: attribute_type.description,
        name: attribute_type.name,
        slug: attribute_type.slug
      )

      @attribute_types.delete_if { |at| at.slug == attribute_type.slug }
      @attribute_types.push(proto_attribute_type)
      @attribute_types.sort_by!{ |at| at.name }

      proto_attribute_type
    end

    def delete_attribute_type(attribute_type)
      @attribute_types.delete_if { |at| at.slug == attribute_type.slug }
    end

    def delete_all_attribute_types
      @attribute_types = []
    end
  end
end
