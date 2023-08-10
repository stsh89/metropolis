defmodule GymnasiumGrpc.Dimensions.Project do
  alias GymnasiumGrpc.Helpers
  alias Gymnasium.{Dimensions.Project, Dimensions}
  alias Proto.Gymnasium.V1.Dimensions.Project, as: ProtoProject

  alias Proto.Gymnasium.V1.{
    FindDimensionRecordResponse,
    ProjectRecordParameters,
    RemoveDimensionRecordResponse,
    SelectDimensionRecordsResponse,
    StoreDimensionRecordResponse
  }

  def select(parameters = %ProjectRecordParameters{}) do
    query_attributes =
      if parameters.archived do
        [archive_indicator: "archived"]
      else
        [archive_indicator: "not_archived"]
      end

    project_records =
      Dimensions.list_projects(query_attributes)
      |> Enum.map(fn project -> to_proto_project(project) end)

    %SelectDimensionRecordsResponse{
      records: {:project_records, %{records: project_records}}
    }
  end

  def store(project = %ProtoProject{}) do
    result =
      case project.id do
        "" -> create(project)
        _ -> update(project)
      end

    store_response(result)
  end

  def find(slug) do
    project_record =
      slug
      |> do_find
      |> to_proto_project

    %FindDimensionRecordResponse{
      record: {:project_record, project_record}
    }
  end

  def get(id) do
    project_record =
      id
      |> do_get
      |> to_proto_project

    %FindDimensionRecordResponse{
      record: {:project_record, project_record}
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
      {field, {message, _validation}} ->
        raise GRPC.RPCError, status: :invalid_argument, message: "#{field}: #{message}"

      _ ->
        raise GRPC.RPCError, status: :invalid_argument
    end
  end

  defp create(proto_project = %ProtoProject{}) do
    archived_at =
      if proto_project.archivation_time do
        Helpers.from_proto_timestamp(proto_project.archivation_time)
      end

    attributes = %{
      archived_at: archived_at,
      description: proto_project.description,
      name: proto_project.name,
      slug: proto_project.slug
    }

    Dimensions.create_project(attributes)
  end

  defp update(proto_project = %ProtoProject{id: id}) do
    archived_at =
      if proto_project.archivation_time do
        Helpers.from_proto_timestamp(proto_project.archivation_time)
      end

    attributes = %{
      archived_at: archived_at,
      description: proto_project.description,
      name: proto_project.name,
      slug: proto_project.slug
    }

    project = do_get(id)

    Dimensions.update_project(project, attributes)
  end

  def remove(id) do
    result =
      id
      |> do_get
      |> Dimensions.delete_project()

    case result do
      {:ok, %Project{}} ->
        %RemoveDimensionRecordResponse{}

      {:error, %Ecto.Changeset{}} ->
        raise GRPC.RPCError, status: :invalid_argument
    end
  end

  defp to_proto_project(project = %Project{}) do
    archivation_time = if project.archived_at, do: Helpers.to_proto_timestamp(project.archived_at)

    %ProtoProject{
      archivation_time: archivation_time,
      create_time: Helpers.to_proto_timestamp(project.inserted_at),
      description: project.description,
      id: project.id,
      name: project.name,
      slug: project.slug
    }
  end

  defp do_find(slug) do
    try do
      Dimensions.find_project!(slug)
    rescue
      Ecto.NoResultsError -> raise GRPC.RPCError, status: :not_found
    end
  end

  defp do_get(id) do
    try do
      Dimensions.get_project!(id)
    rescue
      Ecto.NoResultsError ->
        raise GRPC.RPCError, status: :not_found

      Ecto.Query.CastError ->
        raise GRPC.RPCError, status: :invalid_argument, message: "malformed UUID"
    end
  end
end
