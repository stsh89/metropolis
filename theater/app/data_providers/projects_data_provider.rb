require "#{Rails.root}/lib/proto/temple/v1/projects_pb"
require "#{Rails.root}/lib/proto/temple/v1/projects_services_pb.rb"
require 'google/protobuf/well_known_types'

class ProjectsDataProvider
  def initialize
    @stub = Proto::Temple::V1::Projects::Stub
      .new(TheaterConfig.projects_client.socket_address, :this_channel_is_insecure)
  end

  def list_projects
    message = @stub.list_projects(Proto::Temple::V1::ListProjectsRequest.new())

    message.projects.map do |proto_project|
      ProjectsDataProvider.from_proto(proto_project)
    end
  end

  def create_project(attributes)
    message = @stub.create_project(Proto::Temple::V1::CreateProjectRequest.new(
      name: attributes[:name],
      description: attributes[:description]
    ))

    ProjectsDataProvider.from_proto(message.project)
  end

  def get_project(slug)
    message = @stub.get_project(Proto::Temple::V1::GetProjectRequest.new(
      slug: slug
    ))

    ProjectsDataProvider.from_proto(message.project)
  end

  def list_archived_projects
    message = @stub.list_archived_projects(Proto::Temple::V1::ListArchivedProjectsRequest.new())

    message.projects.map do |proto_project|
      ProjectsDataProvider.from_proto(proto_project)
    end
  end

  def archive_project(project_slug)
    @stub.archive_project(Proto::Temple::V1::ArchiveProjectRequest.new(
      slug: project_slug
    ))
  end

  def restore_project(project_slug)
    @stub.restore_project(Proto::Temple::V1::RestoreProjectRequest.new(
      slug: project_slug
    ))
  end

  def delete_project(project_slug)
    @stub.delete_project(Proto::Temple::V1::DeleteProjectRequest.new(
      slug: project_slug
    ))
  end

  class << self
    def from_proto(proto_project)
      Project.new(
        description: proto_project.description,
        name: proto_project.name,
        slug: proto_project.slug
      )
    end
  end
end
