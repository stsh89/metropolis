require "#{Rails.root}/lib/proto/temple/v1/projects_pb"
require "#{Rails.root}/lib/proto/temple/v1/projects_services_pb.rb"
require 'google/protobuf/well_known_types'

class ModelAssociationDataProvider
  def initialize
    @stub = Proto::Temple::V1::Projects::Stub
      .new(TheaterConfig.projects_client.socket_address, :this_channel_is_insecure)
  end

  def create_model_association(attributes)
    request = Proto::Temple::V1::CreateModelAssociationRequest.new(attributes)

    message = @stub.create_model_association(request)

    ModelAssociationDataProvider.from_proto(message.model_association)
  end

  def delete_model_association(project_slug:, model_slug:, model_association_name:)
    @stub.delete_model_association(Proto::Temple::V1::DeleteModelAssociationRequest.new(
      project_slug: project_slug,
      model_slug: model_slug,
      model_association_name: model_association_name
    ))
  end

  class << self
    def from_proto(proto_model_association)
      ModelAssociation.new(
        description: proto_model_association.description,
        kind: proto_model_association.kind,
        model: ModelsDataProvider.from_proto(proto_model_association.model),
        name: proto_model_association.name
      )
    end
  end
end
