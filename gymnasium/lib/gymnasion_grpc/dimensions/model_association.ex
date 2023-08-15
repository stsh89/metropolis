defmodule GymnasiumGrpc.Dimensions.ModelAssociation do
  alias GymnasiumGrpc.Helpers
  alias Gymnasium.{Dimensions.ModelAssociation, Dimensions}
  alias Proto.Gymnasium.V1.Dimensions.ModelAssociation, as: ProtoModelAssociation

  alias Proto.Gymnasium.V1.{
    CreateModelAssociationRecordResponse,
    GetModelAssociationRecordResponse,
    DeleteModelAssociationRecordResponse
  }

  def create(attrs \\ %{}) do
    model_association_record =
      Dimensions.create_model_association(%{
        model_id: attrs.model_id,
        associated_model_id: attrs.associated_model_id,
        description: attrs.description,
        kind: kind_from_proto(attrs.kind),
        name: attrs.name
      })
      |> to_proto_model_association

    %CreateModelAssociationRecordResponse{
      model_association_record: model_association_record
    }
  end

  def find(attrs \\ %{}) do
    model_association_record =
      attrs
      |> Dimensions.find_model_association!()
      |> to_proto_model_association

    %GetModelAssociationRecordResponse{
      model_association_record: model_association_record
    }
  end

  def delete(id) do
    model_association = Dimensions.get_model_association!(id)

    {:ok, _model_association} = Dimensions.delete_model_association(model_association)

    %DeleteModelAssociationRecordResponse{}
  end

  defp kind_from_proto(:BelongsTo), do: "belongs_to"
  defp kind_from_proto(:HasOne), do: "has_one"
  defp kind_from_proto(:HasMany), do: "has_many"
  defp kind_from_proto(_), do: "unspecified"

  defp kind_to_proto("belongs_to"), do: :BelongsTo
  defp kind_to_proto("has_one"), do: :HasOne
  defp kind_to_proto("has_many"), do: :HasMany
  defp kind_to_proto(_), do: :UnspecifiedAssociationKind

  def to_proto_model_association(%ModelAssociation{} = model_association) do
    %ProtoModelAssociation{
      id: model_association.id,
      model_id: model_association.model_id,
      associated_model:
        GymnasiumGrpc.Dimensions.Model.to_proto_model(model_association.associated_model),
      description: model_association.description,
      kind: kind_to_proto(model_association.kind),
      name: model_association.name,
      create_time: Helpers.to_proto_timestamp(model_association.inserted_at),
      update_time: Helpers.to_proto_timestamp(model_association.updated_at)
    }
  end
end
