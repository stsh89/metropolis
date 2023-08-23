require "#{Rails.root}/lib/proto/temple/v1/projects_pb"
require "#{Rails.root}/lib/proto/temple/v1/projects_services_pb.rb"
require 'google/protobuf/well_known_types'

class ProjectsApi
  def initialize
    @stub = Proto::Temple::V1::Projects::Stub
      .new(TheaterConfig.projects_client.socket_address, :this_channel_is_insecure)
  end

  def create_project(project)
    @stub.create_project(Proto::Temple::V1::CreateProjectRequest.new(
      name: project.name,
      description: project.description
    ))
  end

  def list_projects
    @stub.list_projects(Proto::Temple::V1::ListProjectsRequest.new())
  end

  def get_project(slug)
    @stub.get_project(Proto::Temple::V1::GetProjectRequest.new(
      slug: slug
    ))
  end

  def rename_project(id:, new_name:)
    @stub.rename_project(Proto::Temple::V1::RenameProjectRequest.new(
      name: new_name,
      slug: id
    ))
  end
end
