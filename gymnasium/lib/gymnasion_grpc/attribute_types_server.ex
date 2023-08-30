defmodule GymnasiumGrpc.AttributeTypesServer do
  @moduledoc false

  use GRPC.Server, service: Proto.Gymnasium.V1.AttributeTypes.AttributeTypes.Service

  alias Gymnasium.AttributeTypes.AttributeType
  alias GymnasiumGrpc.Util
  alias Proto.Gymnasium.V1.AttributeTypes, as: Rpc
  alias GymnasiumGrpc.AttributeTypeService

  def create_attribute_type(%Rpc.CreateAttributeTypeRequest{} = request, _stream) do
    %Rpc.CreateAttributeTypeRequest{
      description: description,
      name: name,
      slug: slug
    } = request

    attributes = %AttributeTypeService.CreateAttributeTypeAttributes{
      description: description,
      name: name,
      slug: slug
    }

    attributes
    |> AttributeTypeService.create_attribute_type()
    |> to_proto_attribute_type()
  end

  def find_attribute_type(%Rpc.FindAttributeTypeRequest{} = request, _stream) do
    %Rpc.FindAttributeTypeRequest{
      slug: slug
    } = request

    slug
    |> AttributeTypeService.find_attribute_type()
    |> to_proto_attribute_type()
  end

  def list_attribute_types(%Rpc.ListAttributeTypesRequest{} = _request, _stream) do
    attribute_types =
      AttributeTypeService.list_attribute_types()
      |> Enum.map(fn at -> to_proto_attribute_type(at) end)

    %Rpc.ListAttributeTypesResponse{
      attribute_types: attribute_types
    }
  end

  def update_attribute_type(%Rpc.UpdateAttributeTypeRequest{} = request, _stream) do
    %Rpc.UpdateAttributeTypeRequest{
      attribute_type: attribute_type,
      update_mask: update_mask
    } = request

    attribute_type
    |> from_proto_attribute_type()
    |> AttributeTypeService.update_attribute_type(update_mask.paths)
    |> to_proto_attribute_type()
  end

  def delete_attribute_type(%Rpc.DeleteAttributeTypeRequest{} = request, _stream) do
    %Rpc.DeleteAttributeTypeRequest{
      id: id
    } = request

    AttributeTypeService.delete_attribute_type(id)

    %Google.Protobuf.Empty{}
  end

  defp to_proto_attribute_type(%AttributeType{} = attribute_type) do
    %Rpc.AttributeType{
      id: attribute_type.id,
      description: attribute_type.description,
      name: attribute_type.name,
      slug: attribute_type.slug,
      create_time: Util.to_proto_timestamp(attribute_type.inserted_at),
      update_time: Util.to_proto_timestamp(attribute_type.updated_at)
    }
  end

  defp from_proto_attribute_type(%Rpc.AttributeType{} = proto_attribute_type) do
    %AttributeType{
      id: proto_attribute_type.id,
      description: proto_attribute_type.description,
      name: proto_attribute_type.name,
      slug: proto_attribute_type.slug,
      inserted_at: nil,
      updated_at: nil
    }
  end
end
