require "#{Rails.root}/lib/proto/temple/v1/projects_pb"
require "#{Rails.root}/lib/proto/temple/v1/projects_services_pb.rb"
require 'google/protobuf/well_known_types'

class ModelAttributeDataProvider
  def initialize
    @stub = Proto::Temple::V1::Projects::Stub
      .new(TheaterConfig.projects_client.socket_address, :this_channel_is_insecure)
  end

  def create_model_attribute(attributes)
    message = @stub.create_model_attribute(Proto::Temple::V1::CreateModelAttributeRequest.new(
      project_slug: attributes[:project_slug],
      model_slug: attributes[:model_slug],
      description: attributes[:description],
      name: attributes[:name],
      kind: attributes[:kind]
    ))

    ModelAttributeDataProvider.from_proto(message.model_attribute)
  end

  def delete_model_attribute(project_slug:, model_slug:, model_attribute_name:)
    @stub.delete_model_attribute(Proto::Temple::V1::DeleteModelAttributeRequest.new(
      project_slug: project_slug,
      model_slug: model_slug,
      model_attribute_name: model_attribute_name
    ))
  end

  class << self
    def from_proto(proto_model_attribute)
      ModelAttribute.new(
        description: proto_model_attribute.description,
        kind: proto_model_attribute.kind,
        name: proto_model_attribute.name
      )
    end
  end
end
