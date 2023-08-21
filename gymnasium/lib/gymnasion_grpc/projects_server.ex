defmodule GymnasiumGrpc.ProjectsServer do
  @moduledoc false

  use GRPC.Server, service: Proto.Gymnasium.V1.Projects.Projects.Service

  alias Gymnasium.Projects.Project
  alias GymnasiumGrpc.Util
  alias Proto.Gymnasium.V1.Projects, as: Proto
  alias GymnasiumGrpc.ProjectService

  def create_project(%Proto.CreateProjectRequest{} = request, _stream) do
    %Proto.CreateProjectRequest{
      description: description,
      name: name,
      slug: slug
    } = request

    attributes = %ProjectService.CreateProjectAttributes{
      description: description,
      name: name,
      slug: slug
    }

    case ProjectService.create_project(attributes) do
      %Project{} = project ->
        to_proto_project(project)

      _ ->
        raise GRPC.RPCError, status: :internal
    end
  end

  def find_project(%Proto.FindProjectRequest{} = request, _stream) do
    %Proto.FindProjectRequest{
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

  def list_projects(%Proto.ListProjectsRequest{} = request, _stream) do
    %Proto.ListProjectsRequest{
      archive_state: archive_state
    } = request

    params = [
      archive_state: archive_state_from_proto(archive_state)
    ]

    projects =
      params
      |> ProjectService.list_projects()
      |> Enum.map(fn p -> to_proto_project(p) end)

    %Proto.ListProjectsResponse{
      projects: projects
    }
  end

  def delete_project(%Proto.DeleteProjectRequest{} = request, _stream) do
    %Proto.DeleteProjectRequest{
      id: id
    } = request

    case ProjectService.delete_project(id) do
      :ok ->
        %Google.Protobuf.Empty{}

      :error ->
        raise GRPC.RPCError, status: :internal
    end
  end

  def rename_project(%Proto.RenameProjectRequest{} = request, _stream) do
    %Proto.RenameProjectRequest{
      id: id,
      name: name,
      slug: slug
    } = request

    attributes = %ProjectService.RenameProjectAttributes{
      id: id,
      name: name,
      slug: slug
    }

    case ProjectService.rename_project(attributes) do
      :error ->
        raise GRPC.RPCError, status: :internal

      project ->
        to_proto_project(project)
    end
  end

  def archive_project(%Proto.ArchiveProjectRequest{} = request, _stream) do
    %Proto.ArchiveProjectRequest{
      id: id
    } = request

    case ProjectService.archive_project(id) do
      :ok ->
        %Google.Protobuf.Empty{}

      :error ->
        raise GRPC.RPCError, status: :internal
    end
  end

  def restore_project(%Proto.RestoreProjectRequest{} = request, _stream) do
    %Proto.RestoreProjectRequest{
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
    %Proto.Project{
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
