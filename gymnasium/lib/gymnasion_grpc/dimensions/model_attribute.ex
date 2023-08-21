defmodule GymnasiumGrpc.Dimensions.ModelAttribute do
  alias GymnasiumGrpc.Util
  alias Gymnasium.{Dimensions.ModelAttribute, Dimensions}
  alias Proto.Gymnasium.V1.Dimensions.ModelAttribute, as: ProtoModelAttribute

  alias Proto.Gymnasium.V1.{
    CreateModelAttributeRecordResponse,
    GetModelAttributeRecordResponse,
    DeleteModelAttributeRecordResponse
  }

  def create(attrs \\ %{}) do
    {:ok, model_attribute} =
      Dimensions.create_model_attribute(%{
        model_id: attrs.model_id,
        description: attrs.description,
        kind: kind_from_proto(attrs.kind),
        name: attrs.name
      })

    %CreateModelAttributeRecordResponse{
      model_attribute_record: to_proto_model_attribute(model_attribute)
    }
  end

  def find(attrs \\ %{}) do
    model_attribute_record =
      attrs
      |> Dimensions.find_model_attribute!()
      |> to_proto_model_attribute

    %GetModelAttributeRecordResponse{
      model_attribute_record: model_attribute_record
    }
  end

  def delete(id) do
    model_attribute = Dimensions.get_model_attribute!(id)

    {:ok, _model_attribute} = Dimensions.delete_model_attribute(model_attribute)

    %DeleteModelAttributeRecordResponse{}
  end

  defp kind_from_proto(:Bool), do: "bool"
  defp kind_from_proto(:Int64), do: "integer"
  defp kind_from_proto(:String), do: "string"
  defp kind_from_proto(_), do: "unspecified"

  defp kind_to_proto("bool"), do: :Bool
  defp kind_to_proto("integer"), do: :Int64
  defp kind_to_proto("string"), do: :String
  defp kind_to_proto(_), do: :UnspecifiedAttributeKind

  def to_proto_model_attribute(%ModelAttribute{} = model_attribute) do
    %ProtoModelAttribute{
      id: model_attribute.id,
      model_id: model_attribute.model_id,
      description: model_attribute.description,
      kind: kind_to_proto(model_attribute.kind),
      name: model_attribute.name,
      create_time: Util.to_proto_timestamp(model_attribute.inserted_at),
      update_time: Util.to_proto_timestamp(model_attribute.updated_at)
    }
  end
end
