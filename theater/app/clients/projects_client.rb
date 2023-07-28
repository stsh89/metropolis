require "#{Rails.root}/lib/projects_pb"
require "#{Rails.root}/lib/projects_services_pb.rb"
require 'google/protobuf/well_known_types'

class ProjectsClient
  def list_projects
    [
      Project.new(
        name: 'Metropolis',
        description: 'Highly specialized Architecture Design and Documentation Tool.',
        create_timestamp: DateTime.parse('2023-07-28 14:23:00')
      ),
      Project.new(
        name: 'Diesel',
        description: 'Safe, Extensible ORM and Query Builder for Rust.',
        create_timestamp: DateTime.parse('2023-07-27 17:11:10')
      ),
      Project.new(
        name: 'Livebook',
        description: 'Livebook is a web application for writing interactive and collaborative code notebooks.',
        create_timestamp: DateTime.parse('2023-07-25 10:11:25')
      ),
    ]
  end

  def live_list_projects
    stub = Projects::ProjectsService::Stub.new('[::1]:50051', :this_channel_is_insecure)


    # [
    #   Project.new(
    #     name: 'Metropolis',
    #     description: 'Highly specialized Architecture Design and Documentation Tool.',
    #     create_timestamp: DateTime.parse('2023-07-28 14:23:00')
    #   ),
    #   Project.new(
    #     name: 'Diesel',
    #     description: 'Safe, Extensible ORM and Query Builder for Rust.',
    #     create_timestamp: DateTime.parse('2023-07-27 17:11:10')
    #   ),
    #   Project.new(
    #     name: 'Livebook',
    #     description: 'Livebook is a web application for writing interactive and collaborative code notebooks.',
    #     create_timestamp: DateTime.parse('2023-07-25 10:11:25')
    #   ),
    # ]
    # stub = Proto::ProjectsService::Service.new('[::1]:50051', :this_channel_is_insecure)
    message = stub.list_projects(Projects::ListProjectsRequest.new())
    message.projects.map do |project|
      Project.new(
        name: project.name,
        description: project.description,
        create_timestamp: project.create_timestamp.to_time
      )
    end
  end
end
