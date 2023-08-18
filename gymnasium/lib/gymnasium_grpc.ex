defmodule Proto.Gymnasium.V1.Dimensions.Server do
  use GRPC.Server, service: Proto.Gymnasium.V1.Dimensions.Service

  alias Proto.Gymnasium.V1.{
    ListProjectRecordsRequest,
    CreateProjectRecordRequest,
    GetProjectRecordRequest,
    ArchiveProjectRecordRequest,
    RestoreProjectRecordRequest,
    DeleteProjectRecordRequest,
    CreateModelRecordRequest,
    ListModelRecordsRequest,
    DeleteModelRecordRequest,
    GetModelRecordRequest,
    CreateModelAttributeRecordRequest,
    GetModelAttributeRecordRequest,
    DeleteModelAttributeRecordRequest,
    CreateModelAssociationRecordRequest,
    GetModelAssociationRecordRequest,
    DeleteModelAssociationRecordRequest
  }

  def list_project_records(%ListProjectRecordsRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.Project.list(%{archived: request.archived})
  end

  def create_project_record(%CreateProjectRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.Project.create(%{
      description: request.description,
      name: request.name,
      slug: request.slug
    })
  end

  def get_project_record(%GetProjectRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.Project.find(request.slug)
  end

  def archive_project_record(%ArchiveProjectRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.Project.archive(request.id)
  end

  def restore_project_record(%RestoreProjectRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.Project.restore(request.id)
  end

  def delete_project_record(%DeleteProjectRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.Project.delete(request.id)
  end

  def create_model_record(%CreateModelRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.Model.create(%{
      project_id: request.project_id,
      description: request.description,
      name: request.name,
      slug: request.slug
    })
  end

  def list_model_records(%ListModelRecordsRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.Model.list(%{
      project_slug: request.project_slug
    })
  end

  def delete_model_record(%DeleteModelRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.Model.delete(request.id)
  end

  def get_model_record(%GetModelRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.Model.find(%{
      project_slug: request.project_slug,
      model_slug: request.model_slug,
      preload_attributes: request.preload_attributes,
      preload_associations: request.preload_associations
    })
  end

  def create_model_attribute_record(%CreateModelAttributeRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.ModelAttribute.create(%{
      model_id: request.model_id,
      description: request.description,
      kind: request.kind,
      name: request.name
    })
  end

  def get_model_attribute_record(%GetModelAttributeRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.ModelAttribute.find(%{
      project_slug: request.project_slug,
      model_slug: request.model_slug,
      attribute_name: request.attribute_name
    })
  end

  def delete_model_attribute_record(%DeleteModelAttributeRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.ModelAttribute.delete(request.id)
  end

  def create_model_association_record(%CreateModelAssociationRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.ModelAssociation.create(%{
      model_id: request.model_id,
      associated_model_id: request.associated_model_id,
      description: request.description,
      kind: request.kind,
      name: request.name
    })
  end

  def get_model_association_record(%GetModelAssociationRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.ModelAssociation.find(%{
      project_slug: request.project_slug,
      model_slug: request.model_slug,
      association_name: request.association_name
    })
  end

  def delete_model_association_record(%DeleteModelAssociationRecordRequest{} = request, _stream) do
    GymnasiumGrpc.Dimensions.ModelAssociation.delete(request.id)
  end

  #   def select_dimension_records(request, _stream) do
  #     case request.record_parameters do
  #       {:project_record_parameters, parameters} ->
  #         GymnasiumGrpc.Dimensions.Project.select(parameters)

  #         {:model_record_parameters, parameters} ->
  #             GymnasiumGrpc.Dimensions.Model.select(parameters)

  #       _ ->
  #         raise GRPC.RPCError, status: :invalid_argument
  #     end
  #   end

  #   def store_dimension_record(request, _stream) do
  #     case request.record do
  #       {:project_record, record} ->
  #         GymnasiumGrpc.Dimensions.Project.store(record)

  #         {:model_record, record} ->
  #             GymnasiumGrpc.Dimensions.Model.store(record)

  #       _ ->
  #         raise GRPC.RPCError, status: :invalid_argument
  #     end
  #   end

  #   def find_dimension_record(request, _stream) do
  #     case request.id do
  #       {:project_record_slug, slug} ->
  #         GymnasiumGrpc.Dimensions.Project.find(slug)

  #       {:project_record_id, id} ->
  #         GymnasiumGrpc.Dimensions.Project.get(id)

  #         {:model_record_slug, slug} ->
  #             GymnasiumGrpc.Dimensions.Model.find(slug)

  #           {:model_record_id, id} ->
  #             GymnasiumGrpc.Dimensions.Model.get(id)

  #       _ ->
  #         raise GRPC.RPCError, status: :invalid_argument
  #     end
  #   end

  #   def remove_dimension_record(request, _stream) do
  #     case request.id do
  #       {:project_record_id, id} ->
  #         GymnasiumGrpc.Dimensions.Project.remove(id)

  #       _ ->
  #         raise GRPC.RPCError, status: :invalid_argument
  #     end
  #   end
end
