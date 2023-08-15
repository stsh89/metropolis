require "#{Rails.root}/lib/proto/temple/v1/projects_pb"
require "#{Rails.root}/lib/proto/temple/v1/projects_services_pb.rb"
require 'google/protobuf/well_known_types'

class ModelsDataProvider
  def initialize
    @stub = Proto::Temple::V1::Projects::Stub
      .new(TheaterConfig.projects_client.socket_address, :this_channel_is_insecure)
  end

  def list_models(project_slug)
    message = @stub.list_models(Proto::Temple::V1::ListModelsRequest.new(
      project_slug: project_slug
    ))

    message.models.map do |proto_model|
      ModelsDataProvider.from_proto(proto_model)
    end
  end

  def create_model(attributes)
    message = @stub.create_model(Proto::Temple::V1::CreateModelRequest.new(
      project_slug: attributes[:project_slug],
      name: attributes[:name],
      description: attributes[:description]
    ))

    ModelsDataProvider.from_proto(message.model)
  end

  def get_model(project_slug, model_slug)
    message = @stub.get_model(Proto::Temple::V1::GetModelRequest.new(
      project_slug: project_slug,
      model_slug: model_slug
    ))

    {
      model: ModelsDataProvider.from_proto(message.model),
      attributes: message.attributes.map do |model_attribute|
        ModelAttributeDataProvider.from_proto(model_attribute)
      end
    }
  end

  class << self
    def from_proto(proto_model)
      Model.new(
        description: proto_model.description,
        name: proto_model.name,
        slug: proto_model.slug
      )
    end
  end
end
