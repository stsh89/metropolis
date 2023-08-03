defmodule GymnasiumGrpc.Dimensions.Project do
  alias GymnasiumGrpc.Helpers
  alias Gymnasium.Dimensions.Project
  alias Proto.Gymnasium.V1.Dimensions.Project, as: ProtoProject

  alias Proto.Gymnasium.V1.{
    SelectDimensionRecordsResponse,
    ProjectParameters
  }

  def select(_parameters = %ProjectParameters{}) do
    project_records =
      Gymnasium.Dimensions.list_projects()
      |> Enum.map(fn project -> to_proto_project(project) end)

    %SelectDimensionRecordsResponse{
      records: {:project_records, %{records: project_records}}
    }
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
