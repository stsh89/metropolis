defmodule GymnasiumGrpc.Dimensions.Project do
  alias GymnasiumGrpc.Helpers
  alias Gymnasium.{Dimensions.Project, Dimensions}
  alias Proto.Gymnasium.V1.Dimensions.Project, as: ProtoProject

  alias Proto.Gymnasium.V1.{
    ListProjectRecordsResponse,
    CreateProjectRecordResponse,
    GetProjectRecordResponse,
    ArchiveProjectRecordResponse,
    RestoreProjectRecordResponse,
    DeleteProjectRecordResponse
  }

  def list(attrs \\ []) do
    project_records =
      attrs
      |> Enum.into(%{
        archived: false
      })
      |> Dimensions.list_projects()
      |> Enum.map(fn project -> to_proto_project(project) end)

    %ListProjectRecordsResponse{
      project_records: project_records
    }
  end

  def create(attrs \\ %{}) do
    {:ok, project} = Dimensions.create_project(attrs)

    %CreateProjectRecordResponse{
      project_record: to_proto_project(project)
    }
  end

  def find(slug) do
    project_record =
      slug
      |> Dimensions.find_project!()
      |> to_proto_project

    %GetProjectRecordResponse{
      project_record: project_record
    }
  end

  def archive(id) do
    project = Dimensions.get_project!(id)

    {:ok, project} = Dimensions.archive_project(project)

    %ArchiveProjectRecordResponse{
      project_record: to_proto_project(project)
    }
  end

  def restore(id) do
    project = Dimensions.get_project!(id)

    {:ok, project} = Dimensions.restore_project(project)

    %RestoreProjectRecordResponse{
      project_record: to_proto_project(project)
    }
  end

  def delete(id) do
    project = Dimensions.get_project!(id)

    {:ok, _project} = Dimensions.delete_project(project)

    %DeleteProjectRecordResponse{}
  end

  defp to_proto_project(project = %Project{}) do
    archive_time = if project.archived_at, do: Helpers.to_proto_timestamp(project.archived_at)

    %ProtoProject{
      id: project.id,
      archive_time: archive_time,
      description: project.description,
      name: project.name,
      slug: project.slug,
      create_time: Helpers.to_proto_timestamp(project.inserted_at),
      update_time: Helpers.to_proto_timestamp(project.updated_at)
    }
  end
end
