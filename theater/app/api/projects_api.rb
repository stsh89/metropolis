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

  def create_model(project, model)
    @stub.create_model(Proto::Temple::V1::CreateModelRequest.new(
      project_slug: project.slug,
      name: model.name,
      description: model.description
    ))
  end

  def create_model_attribute(project, model, attribute)
    @stub.create_model_attribute(Proto::Temple::V1::CreateModelAttributeRequest.new(
      project_slug: project.slug,
      model_slug: model.slug,
      description: attribute.description,
      name: attribute.name,
      kind: proto_attribute_kind(attribute.kind),
    ))
  end

  def create_model_association(project, model, association)
    @stub.create_model_association(Proto::Temple::V1::CreateModelAssociationRequest.new(
      project_slug: project.slug,
      model_slug: model.slug,
      description: association.description,
      associated_model_slug: association.associated_model_slug,
      name: association.name,
      kind: proto_association_kind(association.kind),
    ))
  end

  def list_projects
    @stub.list_projects(Proto::Temple::V1::ListProjectsRequest.new())
  end

  def list_archived_projects
    @stub.list_archived_projects(Proto::Temple::V1::ListArchivedProjectsRequest.new())
  end

  def list_models(project)
    @stub.list_models(Proto::Temple::V1::ListModelsRequest.new(
      project_slug: project.slug
    ))
  end

  def get_project(slug)
    @stub.get_project(Proto::Temple::V1::GetProjectRequest.new(
      slug: slug
    ))
  end

  def get_model(project, slug)
    @stub.get_model(Proto::Temple::V1::GetModelRequest.new(
      project_slug: project.slug,
      model_slug: slug
    ))
  end

  def get_model_class_diagram(project, model)
    @stub.get_model_class_diagram(Proto::Temple::V1::GetModelClassDiagramRequest.new(
      project_slug: project.slug,
      model_slug: model.slug
    ))
  end

  def get_project_class_diagram(project)
    @stub.get_project_class_diagram(Proto::Temple::V1::GetProjectClassDiagramRequest.new(
      project_slug: project.slug,
    ))
  end

  def delete_model_attribute(project, model, attribute_name)
    @stub.delete_model_attribute(Proto::Temple::V1::DeleteModelAttributeRequest.new(
      project_slug: project.slug,
      model_slug: model.slug,
      model_attribute_name: attribute_name
    ))
  end

  def delete_model_association(project, model, association_name)
    @stub.delete_model_association(Proto::Temple::V1::DeleteModelAssociationRequest.new(
      project_slug: project.slug,
      model_slug: model.slug,
      model_association_name: association_name
    ))
  end

  def rename_project(project)
    @stub.rename_project(Proto::Temple::V1::RenameProjectRequest.new(
      name: project.name,
      slug: project.slug
    ))
  end

  def archive_project(project)
    @stub.archive_project(Proto::Temple::V1::ArchiveProjectRequest.new(
      slug: project.slug
    ))
  end

  def restore_project(project)
    @stub.archive_project(Proto::Temple::V1::RestoreProjectRequest.new(
      slug: project.slug
    ))
  end

  def delete_project(project)
    @stub.delete_project(Proto::Temple::V1::DeleteProjectRequest.new(
      slug: project.slug
    ))
  end

  def delete_model(project, model)
    @stub.delete_model(Proto::Temple::V1::DeleteModelRequest.new(
      project_slug: project.slug,
      model_slug: model.slug,
    ))
  end

  private

  def proto_attribute_kind(kind)
    case kind
    when "string"
      :MODEL_ATTRIBUTE_KIND_STRING
    when "integer"
      :MODEL_ATTRIBUTE_KIND_INTEGER
    when "boolean"
      :MODEL_ATTRIBUTE_KIND_BOOLEAN
    end
  end

  def proto_association_kind(kind)
    case kind
    when "belongs_to"
      :MODEL_ASSOCIATION_KIND_BELONGS_TO
    when "has_one"
      :MODEL_ASSOCIATION_KIND_HAS_ONE
    when "has_many"
      :MODEL_ASSOCIATION_KIND_HAS_MANY
    end
  end
end
