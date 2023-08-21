defmodule Gymnasium.ProjectModels do
  @moduledoc """
  The context for Models associated with the specific Project.
  """

  import Ecto.Query, warn: false

  alias Gymnasium.Models.{Model, Attribute, Association}
  alias Gymnasium.Projects.Project
  alias Gymnasium.Repo

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

  @doc """
  Lists all models for given Project slug.

  ## Options

      * `preloads` - list of available preloads for Project.

  ## Examples

      iex> list_project_models("book-store")
      [%Model{}]

  """
  @spec list_project_models(String.t(), Keyword.t()) :: [Model.t()]
  def list_project_models(project_slug, opts \\ []) do
    query =
      from m in Model,
        join: p in Project,
        on: p.id == m.project_id,
        where: p.slug == ^project_slug,
        order_by: [asc: m.name]

    query =
      if opts[:preloads] do
        from p in query,
          preload: ^opts[:preloads]
      else
        query
      end

    Repo.all(query)
  end

  @doc """
  Find a specific Model attribute within the context of some Project.

  Raises Ecto.NoResultsError when no model attribute is found.

  ## Examples

      iex> find_project_model_attribute!("book-store", "book", "title")
      %Attribute{}

      iex> find_project_model_attribute!("", "")
      ** (Ecto.NoResultsError)

  """
  @spec find_project_model_attribute!(String.t(), String.t(), String.t()) :: Attribute.t()
  def find_project_model_attribute!(project_slug, model_slug, attribute_name) do
    query =
      from ma in Attribute,
        join: m in Model,
        on: ma.model_id == m.id,
        join: p in Project,
        on: p.id == m.project_id,
        where: p.slug == ^project_slug and m.slug == ^model_slug and ma.name == ^attribute_name,
        order_by: [asc: ma.name]

    Repo.one!(query)
  end

  @doc """
  List all Model attributes within the context of some Project.

  ## Examples

      iex> list_project_model_attributes("book-store", "book")
      %Attribute{}

  """
  @spec list_project_model_attributes(String.t(), String.t()) :: [Attribute.t()]
  def list_project_model_attributes(project_slug, model_slug) do
    query =
      from ma in Attribute,
        join: m in Model,
        on: ma.model_id == m.id,
        join: p in Project,
        on: p.id == m.project_id,
        where: p.slug == ^project_slug and m.slug == ^model_slug,
        order_by: [asc: ma.name]

    Repo.all(query)
  end

  @doc """
  Find a specific Model association within the context of some Project.

  Raises Ecto.NoResultsError when no model association is found.

  ## Examples

      iex> find_project_model_association!("book-store", "book", "title")
      %Association{}

      iex> find_project_model_association!("", "")
      ** (Ecto.NoResultsError)

  """
  @spec find_project_model_association!(String.t(), String.t(), String.t()) ::
          Association.t()
  def find_project_model_association!(project_slug, model_slug, association_name) do
    query =
      from ma in Association,
        join: m in Model,
        on: ma.model_id == m.id,
        join: p in Project,
        on: p.id == m.project_id,
        where: p.slug == ^project_slug and m.slug == ^model_slug and ma.name == ^association_name,
        order_by: [asc: ma.name],
        preload: :associated_model

    Repo.one!(query)
  end

  @doc """
  List all Model associations within the context of some Project.

  ## Examples

      iex> list_project_model_associations("book-store", "book")
      %Association{}

  """
  @spec list_project_model_associations(String.t(), String.t()) :: [Association.t()]
  def list_project_model_associations(project_slug, model_slug) do
    query =
      from ma in Association,
        join: m in Model,
        on: ma.model_id == m.id,
        join: p in Project,
        on: p.id == m.project_id,
        where: p.slug == ^project_slug and m.slug == ^model_slug,
        order_by: [asc: ma.name],
        preload: :associated_model

    Repo.all(query)
  end
end
