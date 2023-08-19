defmodule GymnasiumGrpc.ProjectService do
  alias Gymnasium.Projects
  alias Gymnasium.Dimensions.Project

  @type t :: Project

  @archive_states [:any, :archived_only, :not_archived_only]

  def list_projects(params \\ []) do
    attrs = archive_state_to_project_list_attrs(params[:archive_state])

    Projects.list_projects(attrs)
  end

  @doc """
  Find Project by slug.

  Returns nil if the Project with the given slug does not exist.

  ## Examples

      iex> find_project("bookstore")
      %Project{}

      iex> find_project("filestore")
      nil

  """
  @spec find_project(String.t()) :: t | nil
  def find_project(slug) do
    try do
      Projects.find_project!(slug)
    rescue
      Ecto.NoResultsError -> nil
    end
  end

  @doc """
  Delete Project by it's ID.

  Returns :ok if the Project deleted, returns :error otherwise.

  ## Examples

      iex> delete_project("bookstore")
      :ok

      iex> delete_project("filestore")
      :error

  """
  @spec delete_project(String.t()) :: :ok | :error
  def delete_project(id) do
    try do
      id
      |> Projects.get_project!()
      |> Projects.delete_project!()

      :ok
    rescue
      Ecto.NoResultsError -> :error
      Ecto.StaleEntryError -> :error
      Ecto.NoPrimaryKeyValueError -> :error
      Ecto.Query.CastError -> :error
    end
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
