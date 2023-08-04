require "#{Rails.root}/lib/proto/temple/v1/projects_pb"
require "#{Rails.root}/lib/proto/temple/v1/projects_services_pb.rb"
require 'google/protobuf/well_known_types'

class ProjectsDataProvider
  def list_projects
    stub = Proto::Temple::V1::Projects::Stub.new(TheaterConfig.projects_client.socket_address, :this_channel_is_insecure)

    message = stub.list_projects(Proto::Temple::V1::ListProjectsRequest.new())

    message.projects.map do |proto_project|
      Project.from_proto(proto_project)
    end
  end

  def setup_project_environment(attributes)
    stub = Proto::Temple::V1::Projects::Stub.new(TheaterConfig.projects_client.socket_address, :this_channel_is_insecure)

    message = stub.setup_project_environment(Proto::Temple::V1::SetupProjectEnvironmentRequest.new(
      name: attributes[:name],
      description: attributes[:description]
    ))

    Project.from_proto(message.project)
  end
end
