defmodule GymnasiumGrpc.ModelsServer do
  use GRPC.Server, service: Proto.Gymnasium.V1.Models.Models.Service

  alias Gymnasium.Dimensions.Model
  alias GymnasiumGrpc.Util

  alias Proto.Gymnasium.V1.Models.Model, as: ProtoModel

  alias Proto.Gymnasium.V1.Models.{
    CreateModelRequest,
    DeleteModelRequest,
    ListProjectModelsRequest,
    ListProjectModelsResponse,
    FindProjectModelRequest
  }

  alias GymnasiumGrpc.ModelService
  alias GymnasiumGrpc.ModelService.{CreateModelAttributes, FindProjectModelAttributes}

  def create_model(%CreateModelRequest{} = request, _stream) do
    %CreateModelRequest{
      project_id: project_id,
      description: description,
      name: name,
      slug: slug
    } = request

    attributes = %CreateModelAttributes{
      project_id: project_id,
      description: description,
      name: name,
      slug: slug
    }

    case ModelService.create_model(attributes) do
      %Model{} = model ->
        to_proto_model(model)

      _ ->
        raise GRPC.RPCError, status: :internal
    end
  end

  def list_project_models(%ListProjectModelsRequest{} = request, _stream) do
    %ListProjectModelsRequest{
      project_slug: project_slug
    } = request

    models =
      project_slug
      |> ModelService.list_project_models()
      |> Enum.map(fn m -> to_proto_model(m) end)

    %ListProjectModelsResponse{
      models: models
    }
  end

  def find_project_model(%FindProjectModelRequest{} = request, _stream) do
    %FindProjectModelRequest{
      project_slug: project_slug,
      model_slug: model_slug
    } = request

    case ModelService.find_project_model(%FindProjectModelAttributes{
           project_slug: project_slug,
           model_slug: model_slug
         }) do
      %Model{} = model ->
        to_proto_model(model)

      _ ->
        message =
          "Project with the slug \"#{project_slug}\" does not have a Model with the slug \"#{model_slug}\"."

        raise GRPC.RPCError, status: :not_found, message: message
    end
  end

  def delete_model(%DeleteModelRequest{} = request, _stream) do
    %DeleteModelRequest{
      id: id
    } = request

    case ModelService.delete_model(id) do
      :ok ->
        %Google.Protobuf.Empty{}

      :error ->
        raise GRPC.RPCError, status: :internal
    end
  end

  defp to_proto_model(%Model{} = model) do
    %ProtoModel{
      id: model.id,
      project_id: model.project_id,
      description: model.description,
      name: model.name,
      slug: model.slug,
      create_time: Util.to_proto_timestamp(model.inserted_at),
      update_time: Util.to_proto_timestamp(model.updated_at)
    }
  end
end
