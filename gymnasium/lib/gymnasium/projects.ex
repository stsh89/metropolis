defmodule Gymnasium.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Gymnasium.Repo

  alias Gymnasium.Dimensions.{Project}

  @type t :: %Project{}

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
  @spec list_projects(Keyword.t()) :: t
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
end
