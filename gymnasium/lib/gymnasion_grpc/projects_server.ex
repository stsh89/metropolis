defmodule GymnasiumGrpc.ProjectsServer do
  use GRPC.Server, service: Proto.Gymnasium.V1.Projects.Projects.Service

  alias Gymnasium.Dimensions.Project
  alias GymnasiumGrpc.Util

  alias Proto.Gymnasium.V1.Projects.Project, as: ProtoProject

  alias Proto.Gymnasium.V1.Projects.{
    DeleteProjectRequest,
    FindProjectRequest,
    ListProjectsRequest,
    ListProjectsResponse,
    ArchiveProjectRequest,
    RestoreProjectRequest
  }

  alias GymnasiumGrpc.ProjectService

  def find_project(%FindProjectRequest{} = request, _stream) do
    %FindProjectRequest{
      slug: slug
    } = request

    case ProjectService.find_project(slug) do
      %Project{} = project ->
        to_proto_project(project)

      _ ->
        message = "Project with the slug \"#{slug}\" was not found."
        raise GRPC.RPCError, status: :not_found, message: message
    end
  end

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

  def delete_project(%DeleteProjectRequest{} = request, _stream) do
    %DeleteProjectRequest{
      id: id
    } = request

    case ProjectService.delete_project(id) do
      :ok ->
        %Google.Protobuf.Empty{}

      :error ->
        raise GRPC.RPCError, status: :internal
    end
  end

  def archive_project(%ArchiveProjectRequest{} = request, _stream) do
    %ArchiveProjectRequest{
      id: id
    } = request

    case ProjectService.archive_project(id) do
      :ok ->
        %Google.Protobuf.Empty{}

      :error ->
        raise GRPC.RPCError, status: :internal
    end
  end

  def restore_project(%RestoreProjectRequest{} = request, _stream) do
    %RestoreProjectRequest{
      id: id
    } = request

    case ProjectService.restore_project(id) do
      :ok ->
        %Google.Protobuf.Empty{}

      :error ->
        raise GRPC.RPCError, status: :internal
    end
  end

  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_UNSPECIFIED), do: :any
  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_ARCHIVED), do: :archived_only
  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_NOT_ARCHIVED), do: :not_archived_only
  defp archive_state_from_proto(:PROJECT_ARCHIVE_STATE_ANY), do: :any
  defp archive_state_from_proto(_), do: :any

  defp project_archive_time(%DateTime{} = date_time), do: Util.to_proto_timestamp(date_time)
  defp project_archive_time(_), do: nil

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
end
