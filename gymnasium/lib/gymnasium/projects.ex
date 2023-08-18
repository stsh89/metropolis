defmodule Gymnasium.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Gymnasium.Repo

  alias Gymnasium.Dimensions.{Project}

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects(attrs \\ []) do
    query = from p in Project, order_by: [desc: p.inserted_at]

    query = if attrs[:archived_only] do
      from p in query, where: not is_nil(p.archived_at)
    else
      query
    end

    query = if attrs[:not_archived_only] do
      from p in query, where: is_nil(p.archived_at)
    else
      query
    end

    Repo.all(query)
  end
end
