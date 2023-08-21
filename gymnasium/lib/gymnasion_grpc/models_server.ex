defmodule GymnasiumGrpc.ModelsServer do
  use GRPC.Server, service: Proto.Gymnasium.V1.Models.Models.Service

  alias Gymnasium.Dimensions.{Model, ModelAssociation, ModelAttribute}
  alias GymnasiumGrpc.Util

  alias Proto.Gymnasium.V1.Models.Model, as: ProtoModel
  alias Proto.Gymnasium.V1.Models.Association, as: ProtoAssociation
  alias Proto.Gymnasium.V1.Models.Attribute, as: ProtoAttribute

  alias Proto.Gymnasium.V1.Models.{
    CreateModelRequest,
    DeleteModelRequest,
    ListProjectModelsRequest,
    ListProjectModelsResponse,
    FindProjectModelRequest,
    FindProjectModelAssociationRequest,
    FindProjectModelAttributeRequest,
    CreateAssociationRequest,
    CreateAttributeRequest,
    DeleteAssociationRequest,
    DeleteAttributeRequest,
    ListProjectModelAssociationsRequest,
    ListProjectModelAttributesRequest,
    ListProjectModelAssociationsResponse,
    ListProjectModelAttributesResponse,
    FindProjectModelsOverviewRequest,
    FindProjectModelsOverviewResponse,
    ModelOverview
  }

  alias GymnasiumGrpc.ModelService

  alias GymnasiumGrpc.ModelService.{
    CreateModelAttributes,
    FindProjectModelAttributes,
    FindProjectModelAttributeAttributes,
    FindProjectModelAssociationAttributes,
    CreateAssociationAttributes,
    CreateAttributeAttributes,
    ListProjectModelAttributesAttributes,
    ListProjectModelAssociationsAttributes
  }

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

  def find_project_models_overview(%FindProjectModelsOverviewRequest{} = request, _stream) do
    %FindProjectModelsOverviewRequest{
      project_slug: project_slug
    } = request

    model_overviews =
      project_slug
      |> ModelService.find_project_models_overview()
      |> Enum.map(fn m -> to_proto_model_overview(m) end)

    %FindProjectModelsOverviewResponse{
      model_overviews: model_overviews
    }
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

  def create_association(%CreateAssociationRequest{} = request, _stream) do
    %CreateAssociationRequest{
      model_id: model_id,
      associated_model_id: associated_model_id,
      description: description,
      name: name,
      kind: kind
    } = request

    attributes = %CreateAssociationAttributes{
      model_id: model_id,
      associated_model_id: associated_model_id,
      description: description,
      name: name,
      kind: from_proto_association_kind(kind)
    }

    case ModelService.create_association(attributes) do
      %ModelAssociation{} = association ->
        to_proto_association(association)

      _ ->
        raise GRPC.RPCError, status: :internal
    end
  end

  def list_project_model_associations(%ListProjectModelAssociationsRequest{} = request, _stream) do
    %ListProjectModelAssociationsRequest{
      project_slug: project_slug,
      model_slug: model_slug
    } = request

    attributes = %ListProjectModelAssociationsAttributes{
      project_slug: project_slug,
      model_slug: model_slug
    }

    associations =
      attributes
      |> ModelService.list_project_model_associations()
      |> Enum.map(fn a -> to_proto_association(a) end)

    %ListProjectModelAssociationsResponse{
      associations: associations
    }
  end

  def find_project_model_association(%FindProjectModelAssociationRequest{} = request, _stream) do
    %FindProjectModelAssociationRequest{
      project_slug: project_slug,
      model_slug: model_slug,
      association_name: association_name
    } = request

    case ModelService.find_project_model_association(%FindProjectModelAssociationAttributes{
           project_slug: project_slug,
           model_slug: model_slug,
           association_name: association_name
         }) do
      %ModelAssociation{} = association ->
        to_proto_association(association)

      _ ->
        message =
          "Association \"#{association_name}\" not found for Project \"#{project_slug}\" and Model \"#{model_slug}\"."

        raise GRPC.RPCError, status: :not_found, message: message
    end
  end

  def delete_association(%DeleteAssociationRequest{} = request, _stream) do
    %DeleteAssociationRequest{
      id: id
    } = request

    case ModelService.delete_association(id) do
      :ok ->
        %Google.Protobuf.Empty{}

      :error ->
        raise GRPC.RPCError, status: :internal
    end
  end

  def create_attribute(%CreateAttributeRequest{} = request, _stream) do
    %CreateAttributeRequest{
      model_id: model_id,
      description: description,
      name: name,
      kind: kind
    } = request

    attributes = %CreateAttributeAttributes{
      model_id: model_id,
      description: description,
      name: name,
      kind: from_proto_attribute_kind(kind)
    }

    case ModelService.create_attribute(attributes) do
      %ModelAttribute{} = attribute ->
        to_proto_attribute(attribute)

      _ ->
        raise GRPC.RPCError, status: :internal
    end
  end

  def find_project_model_attribute(%FindProjectModelAttributeRequest{} = request, _stream) do
    %FindProjectModelAttributeRequest{
      project_slug: project_slug,
      model_slug: model_slug,
      attribute_name: attribute_name
    } = request

    case ModelService.find_project_model_attribute(%FindProjectModelAttributeAttributes{
           project_slug: project_slug,
           model_slug: model_slug,
           attribute_name: attribute_name
         }) do
      %ModelAttribute{} = attribute ->
        to_proto_attribute(attribute)

      _ ->
        message =
          "Attribute \"#{attribute_name}\" not found for Project \"#{project_slug}\" and Model \"#{model_slug}\"."

        raise GRPC.RPCError, status: :not_found, message: message
    end
  end

  def list_project_model_attributes(%ListProjectModelAttributesRequest{} = request, _stream) do
    %ListProjectModelAttributesRequest{
      project_slug: project_slug,
      model_slug: model_slug
    } = request

    attributes = %ListProjectModelAttributesAttributes{
      project_slug: project_slug,
      model_slug: model_slug
    }

    attributes =
      attributes
      |> ModelService.list_project_model_attributes()
      |> Enum.map(fn a -> to_proto_attribute(a) end)

    %ListProjectModelAttributesResponse{
      attributes: attributes
    }
  end

  def delete_attribute(%DeleteAttributeRequest{} = request, _stream) do
    %DeleteAttributeRequest{
      id: id
    } = request

    case ModelService.delete_attribute(id) do
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

  defp to_proto_model_overview(%Model{} = model) do
    %ModelOverview{
      model: to_proto_model(model),
      associations: model.associations |> Enum.map(fn a -> to_proto_association(a) end),
      attributes: model.attributes |> Enum.map(fn a -> to_proto_attribute(a) end)
    }
  end

  def to_proto_association(%ModelAssociation{} = association) do
    %ProtoAssociation{
      id: association.id,
      model_id: association.model_id,
      associated_model: to_proto_model(association.associated_model),
      description: association.description,
      kind: to_proto_association_kind(association.kind),
      name: association.name,
      create_time: Util.to_proto_timestamp(association.inserted_at),
      update_time: Util.to_proto_timestamp(association.updated_at)
    }
  end

  def to_proto_attribute(%ModelAttribute{} = attribute) do
    %ProtoAttribute{
      id: attribute.id,
      model_id: attribute.model_id,
      description: attribute.description,
      kind: to_proto_attribute_kind(attribute.kind),
      name: attribute.name,
      create_time: Util.to_proto_timestamp(attribute.inserted_at),
      update_time: Util.to_proto_timestamp(attribute.updated_at)
    }
  end

  defp from_proto_association_kind(:ASSOCIATION_KIND_BELONGS_TO), do: "belongs_to"
  defp from_proto_association_kind(:ASSOCIATION_KIND_HAS_ONE), do: "has_one"
  defp from_proto_association_kind(:ASSOCIATION_KIND_HAS_MANY), do: "has_many"
  defp from_proto_association_kind(_), do: "unspecified"

  defp to_proto_association_kind("belongs_to"), do: :ASSOCIATION_KIND_BELONGS_TO
  defp to_proto_association_kind("has_one"), do: :ASSOCIATION_KIND_HAS_ONE
  defp to_proto_association_kind("has_many"), do: :ASSOCIATION_KIND_HAS_MANY
  defp to_proto_association_kind(_), do: :ASSOCIATION_KIND_UNSPECIFIED

  defp from_proto_attribute_kind(:ATTRIBUTE_KIND_STRING), do: "string"
  defp from_proto_attribute_kind(:ATTRIBUTE_KIND_INTEGER), do: "integer"
  defp from_proto_attribute_kind(:ATTRIBUTE_KIND_BOOLEAN), do: "boolean"
  defp from_proto_attribute_kind(_), do: "unspecified"

  defp to_proto_attribute_kind("string"), do: :ATTRIBUTE_KIND_STRING
  defp to_proto_attribute_kind("integer"), do: :ATTRIBUTE_KIND_INTEGER
  defp to_proto_attribute_kind("boolean"), do: :ATTRIBUTE_KIND_BOOLEAN
  defp to_proto_attribute_kind(_), do: :ATTRIBUTE_KIND_UNSPECIFIED
end
