defmodule GymnasiumGrpc.Dimensions.Project do
  alias GymnasiumGrpc.Helpers
  alias Gymnasium.{Dimensions.Project, Dimensions}
  alias Proto.Gymnasium.V1.Dimensions.Project, as: ProtoProject

  alias Proto.Gymnasium.V1.{
    FindDimensionRecordResponse,
    ProjectRecordParameters,
    SelectDimensionRecordsResponse,
    StoreDimensionRecordResponse
  }

  def select(_parameters = %ProjectRecordParameters{}) do
    project_records =
      Dimensions.list_projects()
      |> Enum.map(fn project -> to_proto_project(project) end)

    %SelectDimensionRecordsResponse{
      records: {:project_records, %{records: project_records}}
    }
  end

  def store(project = %ProtoProject{}) do
    result =
      case project.id do
        "" -> create(project)
        _ -> raise "update is not implemented"
      end

    store_response(result)
  end

  def find(slug) do
    project = Dimensions.get_project!(slug)

    %FindDimensionRecordResponse{
      record: {:project_record, to_proto_project(project)}
    }
  end

  defp store_response({:ok, project = %Project{}}) do
    %StoreDimensionRecordResponse{
      record: {:project_record, to_proto_project(project)}
    }
  end

  defp store_response({:error, changeset = %Ecto.Changeset{}}) do
    error = List.first(changeset.errors)

    case error do
      { field, {message, _validation}} ->
        raise GRPC.RPCError, status: :invalid_argument, message: "#{field}: #{message}"
      _ ->
        raise GRPC.RPCError, status: :invalid_argument
    end
  end

  defp create(project = %ProtoProject{}) do
    attributes = %{
      description: project.description,
      name: project.name,
      slug: project.slug
    }

    Dimensions.create_project(attributes)
  end

  defp to_proto_project(project = %Project{}) do
    %ProtoProject{
      create_time: Helpers.to_proto_timestamp(project.inserted_at),
      description: project.description,
      id: project.id,
      name: project.name,
      slug: project.slug
    }
  end
end
