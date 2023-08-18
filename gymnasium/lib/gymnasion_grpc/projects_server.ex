defmodule GymnasiumGrpc.ProjectsServer do
  use GRPC.Server, service: Proto.Gymnasium.V1.Projects.Projects.Service

  alias Gymnasium.Dimensions.Project
  alias GymnasiumGrpc.Util

  alias Proto.Gymnasium.V1.Projects.Project, as: ProtoProject

  alias Proto.Gymnasium.V1.Projects.{
    ListProjectsRequest,
    ListProjectsResponse
  }

  alias GymnasiumGrpc.ProjectService

  def list_projects(%ListProjectsRequest{} = request, _stream) do
    %ListProjectsRequest{
      archive_state: archive_state
    } = request

    params = [
      archive_state: archive_state_from_proto(archive_state)
    ]

    projects =
      params
      |> ProjectService.list_projects()
      |> Enum.map(fn p -> to_proto_project(p) end)

    %ListProjectsResponse{
      projects: projects
    }
  end

  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_UNSPECIFIED), do: :any
  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_ARCHIVED), do: :archived_only
  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_NOT_ARCHIVED), do: :not_archived_only
  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_ANY), do: :any
  defp archive_state_from_proto(_), do: :any

  defp to_proto_project(%Project{} = project) do
    %ProtoProject{
      id: project.id,
      archive_time: project_archive_time(project.archived_at),
      description: project.description,
      name: project.name,
      slug: project.slug,
      create_time: Util.to_proto_timestamp(project.inserted_at),
      update_time: Util.to_proto_timestamp(project.updated_at)
    }
  end

  defp project_archive_time(%DateTime{} = date_time) do
    Util.to_proto_timestamp(date_time)
  end

  defp project_archive_time(_) do
    nil
  end
end
