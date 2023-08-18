defmodule GymnasiumGrpc.Dimensions.Model do
  alias GymnasiumGrpc.Util
  alias Gymnasium.{Dimensions.Model, Dimensions}
  alias Proto.Gymnasium.V1.Dimensions.Model, as: ProtoModel

  alias Proto.Gymnasium.V1.{
    CreateModelRecordResponse,
    ListModelRecordsResponse,
    DeleteModelRecordResponse,
    GetModelRecordResponse
  }

  def create(attrs \\ %{}) do
    {:ok, model} = Dimensions.create_model(attrs)

    %CreateModelRecordResponse{
      model_record: to_proto_model(model)
    }
  end

  def list(attrs \\ %{}) do
    model_records =
      attrs
      |> Dimensions.list_models()
      |> Enum.map(fn model -> to_proto_model(model) end)

    %ListModelRecordsResponse{
      model_records: model_records
    }
  end

  def delete(id) do
    model = Dimensions.get_model!(id)

    {:ok, _model} = Dimensions.delete_model(model)

    %DeleteModelRecordResponse{}
  end

  def find(attrs \\ %{}) do
    model = Dimensions.find_model!(attrs)

    model_association_records =
      if attrs[:preload_associations] == true do
        Enum.map(
          model.associations,
          fn association ->
            GymnasiumGrpc.Dimensions.ModelAssociation.to_proto_model_association(association)
          end
        )
      else
        []
      end

    model_attribute_records =
      if attrs[:preload_attributes] == true do
        Enum.map(
          model.attributes,
          fn attribute ->
            GymnasiumGrpc.Dimensions.ModelAttribute.to_proto_model_attribute(attribute)
          end
        )
      else
        []
      end

    %GetModelRecordResponse{
      model_record: to_proto_model(model),
      model_association_records: model_association_records,
      model_attribute_records: model_attribute_records
    }
  end

  def to_proto_model(%Model{} = model) do
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
