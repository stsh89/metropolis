defmodule GymnasiumGrpc.ProjectsServer do
  use GRPC.Server, service: Proto.Gymnasium.V1.Projects.Projects.Service

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

    projects = ProjectService.list_projects(params)

    %ListProjectsResponse {
      projects: projects
    }
  end

  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_UNSPECIFIED), do: :any
  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_ARCHIVED), do: :archived_only
  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_NOT_ARCHIVED), do: :not_archived_only
  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_ANY), do: :any
  defp archive_state_from_proto(_), do: :any
end
