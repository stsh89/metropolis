require "#{Rails.root}/lib/proto/temple/v1/projects_pb"
require "#{Rails.root}/lib/proto/temple/v1/projects_services_pb.rb"
require 'google/protobuf/well_known_types'

class ProjectsDataProvider
  def initialize
    @stub = Proto::Temple::V1::Projects::Stub
      .new(TheaterConfig.projects_client.socket_address, :this_channel_is_insecure)
  end

  def showcase_projects
    message = @stub.showcase_projects(Proto::Temple::V1::ShowcaseProjectsRequest.new())

    message.projects.map do |proto_project|
      ProjectsDataProvider.from_proto(proto_project)
    end
  end

  def initialize_project(attributes)
    message = @stub.initialize_project(Proto::Temple::V1::InitializeProjectRequest.new(
      name: attributes[:name],
      description: attributes[:description]
    ))

    ProjectsDataProvider.from_proto(message.project)
  end

  def check_project_details(project_slug)
    message = @stub.check_project_details(Proto::Temple::V1::CheckProjectDetailsRequest.new(
      slug: project_slug
    ))

    ProjectsDataProvider.from_proto(message.project)
  end

  def inquire_archived_projects
    message = @stub.inquire_archived_projects(Proto::Temple::V1::InquireArchivedProjectsRequest.new())

    message.projects.map do |proto_project|
      ProjectsDataProvider.from_proto(proto_project)
    end
  end

  def archive_project(id)
    message = @stub.archive_project(Proto::Temple::V1::ArchiveProjectRequest.new(
      id: id
    ))

    ProjectsDataProvider.from_proto(message.project)
  end

  def recover_project(id)
    message = @stub.recover_project(Proto::Temple::V1::RecoverProjectRequest.new(
      id: id
    ))

    ProjectsDataProvider.from_proto(message.project)
  end

  def delete_project(id)
    @stub.delete_project(Proto::Temple::V1::DeleteProjectRequest.new(
      id: id
    ))
  end

  class << self
    def from_proto(proto_project)
      Project.new(
        create_time: proto_project.create_time.to_time,
        description: proto_project.description,
        id: proto_project.id,
        name: proto_project.name,
        slug: proto_project.slug
      )
    end
  end
end
