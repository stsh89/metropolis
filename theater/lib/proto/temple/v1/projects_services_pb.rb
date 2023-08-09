# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: proto/temple/v1/projects.proto for package 'proto.temple.v1'

require 'grpc'
require 'proto/temple/v1/projects_pb'

module Proto
  module Temple
    module V1
      module Projects
        # List of available actions around Project resource.
        class Service

          include ::GRPC::GenericService

          self.marshal_class_method = :encode
          self.unmarshal_class_method = :decode
          self.service_name = 'proto.temple.v1.Projects'

          # List showcased Projects.
          rpc :ShowcaseProjects, ::Proto::Temple::V1::ShowcaseProjectsRequest, ::Proto::Temple::V1::ShowcaseProjectsResponse
          # Create a Project.
          rpc :InitializeProject, ::Proto::Temple::V1::InitializeProjectRequest, ::Proto::Temple::V1::InitializeProjectResponse
          # Change Project's name.
          rpc :RenameProject, ::Proto::Temple::V1::RenameProjectRequest, ::Proto::Temple::V1::RenameProjectResponse
          # Show Project details.
          rpc :CheckProjectDetails, ::Proto::Temple::V1::CheckProjectDetailsRequest, ::Proto::Temple::V1::CheckProjectDetailsResponse
          # Move a Project from the Showcase to the Museum.
          rpc :ArchiveProject, ::Proto::Temple::V1::ArchiveProjectRequest, ::Proto::Temple::V1::ArchiveProjectResponse
          # Move a Project from the Museum to the Showcase.
          rpc :RecoverProject, ::Proto::Temple::V1::RecoverProjectRequest, ::Proto::Temple::V1::RecoverProjectResponse
          # Get a list of archived Projects.
          rpc :InquireArchivedProjects, ::Proto::Temple::V1::InquireArchivedProjectsRequest, ::Proto::Temple::V1::InquireArchivedProjectsResponse
          # Purge a Project from the Museum history.
          rpc :DeleteProject, ::Proto::Temple::V1::DeleteProjectRequest, ::Proto::Temple::V1::DeleteProjectResponse
        end

        Stub = Service.rpc_stub_class
      end
    end
  end
end
