defmodule GymnasiumGrpc.ProjectService do
  alias Gymnasium.Projects

  @archive_states [:any, :archived_only, :not_archived_only]

  def list_projects(params \\ []) do
    attrs = archive_state_to_project_list_attrs(params[:archive_state])

    Projects.list_projects(attrs)
  end

  defp archive_state_to_project_list_attrs(archive_state) when archive_state in @archive_states do
    case archive_state do
      :any ->
        []

      :archived_only ->
        [archived_only: true]

      :not_archived_only ->
        [not_archived_only: true]
    end
  end

  defp archive_state_to_project_list_attrs(_), do: []
end
