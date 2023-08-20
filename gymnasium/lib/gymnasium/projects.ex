defmodule Gymnasium.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Gymnasium.Repo

  alias Gymnasium.Dimensions.{Project, Model, ModelAttribute, ModelAssociation}

  @type t :: %Project{}

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_project(map()) :: {:ok, t} | {:error, %Ecto.Changeset{}}
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of projects.

  ## Options

    * `:archived_only` - only Projects with available `archived_at` timestamp
      will be returned.
    * `:not_archived_only` - only Projects without `archived_at` timestamp
      will be returned.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  @spec list_projects(Keyword.t()) :: [t]
  def list_projects(attrs \\ []) do
    query = from p in Project, order_by: [desc: p.inserted_at]

    query =
      if attrs[:archived_only] do
        from p in query, where: not is_nil(p.archived_at)
      else
        query
      end

    query =
      if attrs[:not_archived_only] do
        from p in query, where: is_nil(p.archived_at)
      else
        query
      end

    Repo.all(query)
  end

  @doc """
  Find a single project by it's slug.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> find_project!("bookstore")
      %Project{}

      iex> find_project!("filestore")
      ** (Ecto.NoResultsError)

  """
  @spec find_project!(String.t()) :: t
  def find_project!(slug), do: Repo.get_by!(Project, slug: slug)

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!("8e3b5275-bc1b-4490-a2d8-23c68d9b0fd5")
      %Project{}

      iex> get_project!("8844f7c8-1f83-4fdf-817f-41780c9e5d05")
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Deletes a Project.

  Returns the struct or raises `Ecto.NoResultsError` if the changeset is invalid.

  ## Examples

      iex> delete_project!(project)
      %Project{}

      iex> delete_project(project)
      ** (Ecto.NoResultsError)

  """
  @spec delete_project!(Project.t()) :: {:ok, Project.t()} | {:error, Project.t()}
  def delete_project!(%Project{} = project) do
    model_ids =
      if project.id == nil do
        []
      else
        Repo.all(from m in Model, where: m.project_id == ^project.id, select: m.id)
      end

    model_association_ids =
      Repo.all(from ma in ModelAssociation, where: ma.model_id in ^model_ids, select: ma.id)

    model_attribute_ids =
      Repo.all(from ma in ModelAttribute, where: ma.model_id in ^model_ids, select: ma.id)

    Repo.transaction(fn ->
      Repo.delete_all(from m in Model, where: m.id in ^model_ids)
      Repo.delete_all(from ma in ModelAssociation, where: ma.id in ^model_association_ids)
      Repo.delete_all(from ma in ModelAttribute, where: ma.id in ^model_attribute_ids)

      Repo.delete!(project)
    end)
  end

  @doc """
  Sets archivation timestamp on a project.
  Updates archivation timestamp if a project was already archived.

  ## Examples

      iex> archive_project()
      {:ok, %Project{}}

      iex> archive_project()
      {:error, %Ecto.Changeset{}}

  """
  @spec archive_project(Project.t()) :: {:ok, Project.t()} | {:error, %Ecto.Changeset{}}
  def archive_project(%Project{} = project) do
    project
    |> change_project(%{archived_at: DateTime.utc_now()})
    |> Repo.update()
  end

  @doc """
  Removes archivation timestamp from a project.
  Does nothing if a project was not archived.

  ## Examples

      iex> restore_project()
      {:ok, %Project{}}

      iex> restore_project()
      {:error, %Ecto.Changeset{}}

  """
  @spec restore_project(Project.t()) :: {:ok, Project.t()} | {:error, %Ecto.Changeset{}}
  def restore_project(%Project{} = project) do
    project
    |> change_project(%{archived_at: nil})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end
end
