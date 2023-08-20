defmodule GymnasiumGrpc.ProjectService do
  alias Gymnasium.Projects
  alias Gymnasium.Dimensions.Project
  alias GymnasiumGrpc.ProjectService.{CreateProjectAttributes, RenameProjectAttributes}

  @type t :: Project

  @archive_states [:any, :archived_only, :not_archived_only]

  @doc """
  Create a Project.

  ## Examples

      iex> create_project(%CreateProjectAttributes{name: "Book store", slug: "book-store"})
      %Project{}

      iex> create_project(%CreateProjectAttributes{})
      :error

  """
  @spec create_project(CreateProjectAttributes.t()) :: t | :error
  def create_project(%CreateProjectAttributes{} = attributes) do
    result =
      attributes
      |> Map.from_struct()
      |> Projects.create_project()

    case result do
      {:ok, project} ->
        project

      {:error, _changset} ->
        :error
    end
  end

  @doc """
  Rename a Project.

  ## Examples

      iex> rename_project(%RenameProjectAttributes{
      ...>   id: "29b5098f-abfa-45ed-9ff2-1e76ece9fe58",
      ...>   name: "Book store",
      ...>   slug: "book-store"
      ...> })
      %Project{}

      iex> rename_project(%RenameProjectAttributes{})
      :error

  """
  @spec rename_project(RenameProjectAttributes.t()) :: t | :error
  def rename_project(%RenameProjectAttributes{} = attributes) do
    try do
      %RenameProjectAttributes{
        id: id,
        name: name,
        slug: slug
      } = attributes

      result =
        id
        |> Projects.get_project!()
        |> Projects.update_project(%{name: name, slug: slug})

      case result do
        {:ok, project} ->
          project

        {:error, _changset} ->
          :error
      end
    rescue
      Ecto.NoResultsError -> :error
      Ecto.Query.CastError -> :error
    end
  end

  @doc """
  Returns the list of projects.

  ## Options
      * `archive_state` - can be one of `:any`, `:archived_only`, `:not_archived_only`

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  @spec list_projects(Keyword.t()) :: [t]
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

  @doc """
  Archives a project.

  ## Examples

      iex> archive_project("bookstore")
      :ok

      iex> archive_project("filestore")
      :error

  """
  @spec archive_project(String.t()) :: :ok | :error
  def archive_project(id) do
    try do
      result =
        id
        |> Projects.get_project!()
        |> Projects.archive_project()

      case result do
        {:ok, _} ->
          :ok

        {:error, _} ->
          :error
      end
    rescue
      Ecto.NoResultsError -> :error
      Ecto.Query.CastError -> :error
    end
  end

  @doc """
  Restores a project from archive.

  ## Examples

      iex> restore_project("bookstore")
      :ok

      iex> restore_project("filestore")
      :error

  """
  @spec restore_project(String.t()) :: :ok | :error
  def restore_project(id) do
    try do
      result =
        id
        |> Projects.get_project!()
        |> Projects.restore_project()

      case result do
        {:ok, _} ->
          :ok

        {:error, _} ->
          :error
      end
    rescue
      Ecto.NoResultsError -> :error
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
