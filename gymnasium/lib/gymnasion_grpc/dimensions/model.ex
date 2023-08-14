defmodule GymnasiumGrpc.Dimensions.Model do
  alias GymnasiumGrpc.Helpers
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
    model_record =
      attrs
      |> Dimensions.find_model!()
      |> to_proto_model

    %GetModelRecordResponse{
      model_record: model_record
    }
  end

#   def select(parameters = %ModelRecordParameters{}) do
#     query_attributes = %{ project_id: parameters.project_id }

#     model_records =
#       Dimensions.list_models(query_attributes)
#       |> Enum.map(fn model -> to_proto_model(model) end)

#     %SelectDimensionRecordsResponse{
#       records: {:model_records, %{records: model_records}}
#     }
#   end

#   def store(%ProtoModel{} = model) do
#     result =
#       case model.id do
#         "" -> create(model)
#         _ -> update(model)
#       end

#     store_response(result)
#   end

#   def find(project_id, slug) do
#     model_record =
#       project_id
#       |> do_find(slug)
#       |> to_proto_model

#     %FindDimensionRecordResponse{
#       record: {:model_record, model_record}
#     }
#   end

#   def get(id) do
#     model_record =
#       id
#       |> do_get
#       |> to_proto_model

#     %FindDimensionRecordResponse{
#       record: {:model_record, model_record}
#     }
#   end

#   defp store_response({:ok, %Model{} = model}) do
#     %StoreDimensionRecordResponse{
#       record: {:model_record, to_proto_model(model)}
#     }
#   end

#   defp store_response({:error, changeset = %Ecto.Changeset{}}) do
#     error = List.first(changeset.errors)

#     case error do
#       {field, {message, _validation}} ->
#         raise GRPC.RPCError, status: :invalid_argument, message: "#{field}: #{message}"

#       _ ->
#         raise GRPC.RPCError, status: :invalid_argument
#     end
#   end

#   defp create(proto_model = %ProtoModel{}) do
#     archived_at =
#       if proto_model.archivation_time do
#         Helpers.from_proto_timestamp(proto_model.archivation_time)
#       end

#     attributes = %{
#       description: proto_model.description,
#       name: proto_model.name,
#       slug: proto_model.slug,
#       project_id: proto_model.project_id
#     }

#     Dimensions.create_model(attributes)
#   end

#   defp update(%ProtoModel{id: id} = proto_model) do
#     attributes = %{
#       description: proto_model.description,
#       name: proto_model.name,
#       slug: proto_model.slug
#     }

#     model = do_get(id)

#     Dimensions.update_model(model, attributes)
#   end

#   def remove(id) do
#     result =
#       id
#       |> do_get
#       |> Dimensions.delete_model()

#     case result do
#       {:ok, %Model{}} ->
#         %RemoveDimensionRecordResponse{}

#       {:error, %Ecto.Changeset{}} ->
#         raise GRPC.RPCError, status: :invalid_argument
#     end
#   end

#   defp to_proto_model(%Model{} = model) do
#     %ProtoModel{
#       create_time: Helpers.to_proto_timestamp(model.inserted_at),
#       description: model.description,
#       id: model.id,
#       name: model.name,
#       slug: model.slug
#     }
#   end

#   defp do_find(project_id, slug) do
#     try do
#       Dimensions.find_model!(project_id, slug)
#     rescue
#       Ecto.NoResultsError -> raise GRPC.RPCError, status: :not_found
#     end
#   end

#   defp do_get(id) do
#     try do
#       Dimensions.get_model!(id)
#     rescue
#       Ecto.NoResultsError ->
#         raise GRPC.RPCError, status: :not_found

#       Ecto.Query.CastError ->
#         raise GRPC.RPCError, status: :invalid_argument, message: "malformed UUID"
#     end
#   end

  defp to_proto_model(%Model{} = model) do
    %ProtoModel{
      id: model.id,
      project_id: model.project_id,
      description: model.description,
      name: model.name,
      slug: model.slug,
      create_time: Helpers.to_proto_timestamp(model.inserted_at),
      update_time:  Helpers.to_proto_timestamp(model.updated_at)
    }
  end
end
