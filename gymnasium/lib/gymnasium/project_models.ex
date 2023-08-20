defmodule Gymnasium.ProjectModels do
  @moduledoc """
  The context for Models associated with the specific Project.
  """

  import Ecto.Query, warn: false

  alias Gymnasium.Dimensions.{Model, Project}
  alias Gymnasium.Repo

  @doc """
  Lists all models for given Project slug.

  ## Examples

      iex> list_project_models("book-store")
      [%Model{}]

  """
  @spec list_project_models(String.t()) :: [Model.t()]
  def list_project_models(project_slug) do
    query =
      from m in Model,
        join: p in Project,
        on: p.id == m.project_id,
        where: p.slug == ^project_slug,
        order_by: [asc: m.name]

    Repo.all(query)
  end

  @doc """
  Find a specific Model associated with specific Project.

  Raises Ecto.NoResultsError when no model is found.

  ## Examples

      iex> find_project_model!("book-store", "book")
      %Model{}

      iex> find_project_model!("", "")
      ** (Ecto.NoResultsError)

  """
  @spec find_project_model!(String.t(), String.t()) :: Model.t()
  def find_project_model!(project_slug, model_slug) do
    query =
      from m in Model,
        join: p in Project,
        on: p.id == m.project_id,
        where: p.slug == ^project_slug and m.slug == ^model_slug,
        order_by: [asc: m.name]

    Repo.one!(query)
  end
end
