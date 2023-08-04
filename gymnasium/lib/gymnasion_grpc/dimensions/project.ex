defmodule GymnasiumGrpc.Dimensions.Project do
  alias GymnasiumGrpc.Helpers
  alias Gymnasium.{Dimensions.Project, Dimensions}
  alias Proto.Gymnasium.V1.Dimensions.Project, as: ProtoProject

  alias Proto.Gymnasium.V1.{
    SelectDimensionRecordsResponse,
    StoreDimensionRecordResponse,
    ProjectRecordParameters
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

    {:ok, project = %Project{}} = result

    %StoreDimensionRecordResponse{
      record: {:project_record, to_proto_project(project)}
    }
  end

  defp create(project = %ProtoProject{}) do
    attributes = %{
      name: project.name,
      description: project.description
    }

    Dimensions.create_project(attributes)
  end

  defp to_proto_project(project = %Project{}) do
    %ProtoProject{
      id: project.id,
      name: project.name,
      description: project.description,
      create_time: Helpers.to_proto_timestamp(project.inserted_at)
    }
  end
end
