defmodule Gymnasium.Dimensions do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Gymnasium.Repo

  alias Gymnasium.Dimensions.{Project, Model, ModelAttribute, ModelAssociation}

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects(attrs \\ []) do
    query = from p in Project, order_by: [desc: p.inserted_at]

    query =
      case attrs[:archived] do
        true ->
          from p in query, where: not is_nil(p.archived_at)

        _ ->
          from p in query, where: is_nil(p.archived_at)
      end

    Repo.all(query)
  end

  @doc """
  Returns the list of models.

  ## Examples

      iex> list_models()
      [%Model{}, ...]

  """
  def list_models(attrs \\ %{}) do
    query =
      from m in Model,
        join: p in Project,
        on: p.id == m.project_id,
        where: p.slug == ^attrs.project_slug,
        order_by: [desc: m.inserted_at]

    Repo.all(query)
  end

  @doc """
  Returns the list of model attributes.

  ## Examples

      iex> list_model_attributes()
      [%ModelAttribute{}, ...]

  """
  def list_model_attributes(query_attributes \\ %{}) do
    query =
      from ma in ModelAttribute,
        where: [model_id: ^query_attributes.model_id],
        order_by: [desc: ma.inserted_at]

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
  def find_project!(slug), do: Repo.get_by!(Project, slug: slug)

  @doc """
  Find a single model by project's slug and it's slug.

  Raises `Ecto.NoResultsError` if the Project or Model does not exist.

  ## Examples

      iex> find_model!("bookstore")
      %Model{}

      iex> find_model!("filestore")
      ** (Ecto.NoResultsError)

  """
  def find_model!(attrs \\ %{}) do
    query =
      from m in Model,
        join: p in Project,
        on: p.id == m.project_id,
        where: p.slug == ^attrs.project_slug and m.slug == ^attrs.model_slug,
        order_by: [desc: m.name]

    query =
      case attrs[:preload_associations] do
        true ->
          from m in query, preload: [associations: :associated_model]

        _ ->
          query
      end

    query =
      case attrs[:preload_attributes] do
        true ->
          from m in query, preload: :attributes

        _ ->
          query
      end

    Repo.one!(query)
  end

  @doc """
  Find a single model by project's slug and it's slug.

  Raises `Ecto.NoResultsError` if the Project or Model does not exist.

  ## Examples

      iex> find_model_attribute!("Title")
      %Model{}

      iex> find_model_attribute!("Publisher")
      ** (Ecto.NoResultsError)

  """
  def find_model_attribute!(attrs \\ %{}) do
    query =
      from ma in ModelAttribute,
        join: m in Model,
        on: m.id == ma.model_id,
        join: p in Project,
        on: p.id == m.project_id,
        where:
          p.slug == ^attrs.project_slug and m.slug == ^attrs.model_slug and
            ma.name == ^attrs.attribute_name,
        order_by: [desc: ma.name]

    Repo.one!(query)
  end

  @doc """
  Find a single model by project's slug and it's slug.

  Raises `Ecto.NoResultsError` if the Project or Model does not exist.

  ## Examples

      iex> find_model_association!("Title")
      %Model{}

      iex> find_model_association!("Publisher")
      ** (Ecto.NoResultsError)

  """
  def find_model_association!(attrs \\ %{}) do
    query =
      from ma in ModelAssociation,
        join: m in Model,
        on: m.id == ma.model_id,
        join: p in Project,
        on: p.id == m.project_id,
        where:
          p.slug == ^attrs.project_slug and m.slug == ^attrs.model_slug and
            ma.name == ^attrs.association_name,
        order_by: [desc: ma.name],
        preload: :associated_model

    Repo.one!(query)
  end

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
  Archives a project.

  ## Examples

      iex> archive_project(project)
      {:ok, %Project{}}

      iex> archive_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def archive_project(%Project{} = project) do
    project
    |> Project.archive_changeset()
    |> Repo.update()
  end

  @doc """
  Restores a project from archive.

  ## Examples

      iex> restore_project(project)
      {:ok, %Project{}}

      iex> restore_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def restore_project(%Project{} = project) do
    project
    |> Project.restore_changeset()
    |> Repo.update()
  end

  @doc """
  Gets a single model.

  Raises `Ecto.NoResultsError` if the Model does not exist.

  ## Examples

      iex> get_model!("8e3b5275-bc1b-4490-a2d8-23c68d9b0fd5")
      %Model{}

      iex> get_model!("8844f7c8-1f83-4fdf-817f-41780c9e5d05")
      ** (Ecto.NoResultsError)

  """
  def get_model!(id), do: Repo.get!(Model, id)

  @doc """
  Gets a single model attribute.

  Raises `Ecto.NoResultsError` if the Model Attribute does not exist.

  ## Examples

      iex> get_model_attribute!("8e3b5275-bc1b-4490-a2d8-23c68d9b0fd5")
      %Model{}

      iex> get_model_attribute!("8844f7c8-1f83-4fdf-817f-41780c9e5d05")
      ** (Ecto.NoResultsError)

  """
  def get_model_attribute!(id), do: Repo.get!(ModelAttribute, id)

  @doc """
  Gets a single model association.

  Raises `Ecto.NoResultsError` if the Model Attribute does not exist.

  ## Examples

      iex> get_model_association!("8e3b5275-bc1b-4490-a2d8-23c68d9b0fd5")
      %Model{}

      iex> get_model_association!("8844f7c8-1f83-4fdf-817f-41780c9e5d05")
      ** (Ecto.NoResultsError)

  """
  def get_model_association!(id), do: Repo.get!(ModelAssociation, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a model.

  ## Examples

      iex> create_model(%{field: value})
      {:ok, %model{}}

      iex> create_model(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_model(attrs \\ %{}) do
    %Model{}
    |> Model.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a model attribute.

  ## Examples

      iex> create_model_attribute(%{field: value})
      {:ok, %model{}}

      iex> create_model_attribute(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_model_attribute(attrs \\ %{}) do
    %ModelAttribute{}
    |> ModelAttribute.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a model association.

  ## Examples

      iex> create_model_association(%{field: value})
      {:ok, %model{}}

      iex> create_model_association(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_model_association(attrs \\ %{}) do
    {:ok, model_association} =
      %ModelAssociation{}
      |> ModelAssociation.changeset(attrs)
      |> Repo.insert()

    Repo.preload(model_association, :associated_model)
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a model.

  ## Examples

      iex> update_model(model, %{field: new_value})
      {:ok, %Model{}}

      iex> update_model(model, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_model(%Model{} = model, attrs) do
    model
    |> Model.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a model attribute.

  ## Examples

      iex> update_model_attribute(model_attribute, %{field: new_value})
      {:ok, %ModelAttribute{}}

      iex> update_model_attribute(model_attribute, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_model_attribute(%ModelAttribute{} = model, attrs) do
    model
    |> ModelAttribute.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    model_ids = Repo.all(from m in Model, where: m.project_id == ^project.id, select: m.id)

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

    {:ok, project}
  end

  @doc """
  Deletes a model.

  ## Examples

      iex> delete_model(model)
      {:ok, %Model{}}

      iex> delete_model(model)
      {:error, %Ecto.Changeset{}}

  """
  def delete_model(%Model{} = model) do
    Repo.delete(model)
  end

  @doc """
  Deletes a model attribute.

  ## Examples

      iex> delete_model_attribute(model_attribute)
      {:ok, %Model{}}

      iex> delete_model_attribute(model_attribute)
      {:error, %Ecto.Changeset{}}

  """
  def delete_model_attribute(%ModelAttribute{} = model_attribute) do
    Repo.delete(model_attribute)
  end

  @doc """
  Deletes a model association.

  ## Examples

      iex> delete_model_association(model_association)
      {:ok, %Model{}}

      iex> delete_model_association(model_association)
      {:error, %Ecto.Changeset{}}

  """
  def delete_model_association(%ModelAssociation{} = model_association) do
    Repo.delete(model_association)
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

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking model changes.

  ## Examples

      iex> change_model(model)
      %Ecto.Changeset{data: %Model{}}

  """
  def change_model(%Model{} = model, attrs \\ %{}) do
    Model.changeset(model, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking model_attribute changes.

  ## Examples

      iex> change_model_attribute(model_attribute)
      %Ecto.Changeset{data: %Model{}}

  """
  def change_model_attribute(%ModelAttribute{} = model_attribute, attrs \\ %{}) do
    ModelAttribute.changeset(model_attribute, attrs)
  end
end
