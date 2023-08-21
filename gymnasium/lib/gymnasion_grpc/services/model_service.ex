defmodule GymnasiumGrpc.ModelService do
  @moduledoc """
  Entrypoint for all actions around models.
  """

  alias Gymnasium.{Models, ProjectModels}
  alias Gymnasium.Models.{Model, Attribute, Association}

  alias GymnasiumGrpc.ModelService.{
    CreateAssociationAttributes,
    CreateAttributeAttributes,
    CreateModelAttributes,
    FindProjectModelAssociationAttributes,
    FindProjectModelAttributeAttributes,
    FindProjectModelAttributes,
    ListProjectModelAssociationsAttributes,
    ListProjectModelAttributesAttributes
  }

  @doc """
  Create a Model.

  ## Examples

      iex> create_model(%CreateModelAttributes{
      ...>   project_id: "c8e47fc7-dee3-4c57-8955-9b49317f2af2",
      ...>   name: "Book store",
      ...>   slug: "book-store"
      ...>  })
      %Model{}

      iex> create_model(%CreateModelAttributes{})
      :error

  """
  @spec create_model(CreateModelAttributes.t()) :: Model.t() | :error
  def create_model(%CreateModelAttributes{} = attributes) do
    result =
      attributes
      |> Map.from_struct()
      |> Models.create_model()

    case result do
      {:ok, model} ->
        model

      {:error, _changset} ->
        :error
    end
  end

  @doc """
  Returns a list of Models for specific Project.

  ## Examples

      iex> list_project_models("book-store")
      [%Model{}, ...]

  """
  @spec list_project_models(String.t()) :: [Model.t()]
  def list_project_models(project_slug) do
    ProjectModels.list_project_models(project_slug)
  end

  @doc """
  Returns a list of Models for specific Project with attributes and associations.

  ## Examples

      iex> find_project_models_overview("book-store")
      [%Model{}, ...]

  """
  @spec find_project_models_overview(String.t()) :: [Model.t()]
  def find_project_models_overview(project_slug) do
    ProjectModels.list_project_models(project_slug,
      preloads: [:attributes, [associations: :associated_model]]
    )
  end

  @doc """
  Returns a list of model associations.

  ## Examples

      iex> list_project_model_associations(%ListProjectModelAssociationsAttributes{
      ...>   project_slug: "book-store",
      ...>   model_slug: "book"
      ...> })
      [%ModelAssociation{}, ...]

  """
  @spec list_project_model_associations(ListProjectModelAssociationsAttributes.t()) :: [
          Association.t()
        ]
  def list_project_model_associations(%ListProjectModelAssociationsAttributes{} = attributes) do
    %ListProjectModelAssociationsAttributes{
      project_slug: project_slug,
      model_slug: model_slug
    } = attributes

    ProjectModels.list_project_model_associations(project_slug, model_slug)
  end

  @doc """
  Returns a list of model attributes.

  ## Examples

      iex> list_project_model_attributes(%ListProjectModelAttributesAttributes{
      ...>   project_slug: "book-store",
      ...>   model_slug: "book"
      ...> })
      [%ModelAttribute{}, ...]

  """
  @spec list_project_model_attributes(ListProjectModelAttributesAttributes.t()) :: [Attribute.t()]
  def list_project_model_attributes(%ListProjectModelAttributesAttributes{} = attributes) do
    %ListProjectModelAttributesAttributes{
      project_slug: project_slug,
      model_slug: model_slug
    } = attributes

    ProjectModels.list_project_model_attributes(project_slug, model_slug)
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
  @spec find_project_model(FindProjectModelAttributes.t()) :: Model.t() | nil
  def find_project_model(%FindProjectModelAttributes{} = attributes) do
    %FindProjectModelAttributes{
      project_slug: project_slug,
      model_slug: model_slug
    } = attributes

    try do
      ProjectModels.find_project_model!(project_slug, model_slug)
    rescue
      Ecto.NoResultsError -> nil
    end
  end

  @doc """
  Find Project model association.

  Returns nil if the Project with the given slug does not exist.

  ## Examples

      iex> find_project_model_association("bookstore")
      %Project{}

      iex> find_project_model_association("filestore")
      nil

  """
  @spec find_project_model_association(FindProjectModelAssociationAttributes.t()) ::
          Model.t() | nil
  def find_project_model_association(%FindProjectModelAssociationAttributes{} = attributes) do
    %FindProjectModelAssociationAttributes{
      project_slug: project_slug,
      model_slug: model_slug,
      association_name: association_name
    } = attributes

    try do
      ProjectModels.find_project_model_association!(project_slug, model_slug, association_name)
    rescue
      Ecto.NoResultsError -> nil
    end
  end

  @doc """
  Find Project model attribute.

  Returns nil if the Project with the given slug does not exist.

  ## Examples

      iex> find_project_model_attribute("bookstore")
      %Project{}

      iex> find_project_model_attribute("filestore")
      nil

  """
  @spec find_project_model_attribute(FindProjectModelAttributeAttributes.t()) :: Model.t() | nil
  def find_project_model_attribute(%FindProjectModelAttributeAttributes{} = attributes) do
    %FindProjectModelAttributeAttributes{
      project_slug: project_slug,
      model_slug: model_slug,
      attribute_name: attribute_name
    } = attributes

    try do
      ProjectModels.find_project_model_attribute!(project_slug, model_slug, attribute_name)
    rescue
      Ecto.NoResultsError -> nil
    end
  end

  @doc """
  Delete Model by it's ID.

  Returns :ok if the Model deleted, returns :error otherwise.

  ## Examples

      iex> delete_model("book")
      :ok

      iex> delete_model("author")
      :error

  """
  @spec delete_model(String.t()) :: :ok | :error
  def delete_model(id) do
    try do
      id
      |> Models.get_model!()
      |> Models.delete_model!()

      :ok
    rescue
      Ecto.NoResultsError -> :error
      Ecto.StaleEntryError -> :error
      Ecto.NoPrimaryKeyValueError -> :error
      Ecto.Query.CastError -> :error
    end
  end

  @doc """
  Create a Model association.

  ## Examples

      iex> create_association(%CreateAssociationAttributes{
      ...>   model_id: "c8e47fc7-dee3-4c57-8955-9b49317f2af2",
      ...>   associated_model_id: "62858931-87e9-4033-ab1a-823cb24de4fc",
      ...>   description: "Book can be written by some author.",
      ...>   name: "author",
      ...>   kind: "belongs_to"
      ...>  })
      %Model{}

      iex> create_association(%CreateAssociationAttributes{})
      :error

  """
  @spec create_association(CreateAssociationAttributes.t()) :: Association.t() | :error
  def create_association(%CreateAssociationAttributes{} = attributes) do
    result =
      attributes
      |> Map.from_struct()
      |> Models.create_association()

    case result do
      {:ok, association} ->
        association |> Gymnasium.Repo.preload(:associated_model)

      {:error, _changset} ->
        :error
    end
  end

  @doc """
  Delete Model association by it's ID.

  Returns :ok if the Model association deleted, returns :error otherwise.

  ## Examples

      iex> delete_association("55d6e7cf-2de0-428c-bb19-9555d237e160")
      :ok

      iex> delete_association("55d6e7cf-2de0-428c-bb19-9555d237e161")
      :error

  """
  @spec delete_association(String.t()) :: :ok | :error
  def delete_association(id) do
    try do
      result =
        id
        |> Models.get_association!()
        |> Models.delete_association()

      case result do
        {:ok, _} ->
          :ok

        {:error, _} ->
          :error
      end
    rescue
      Ecto.NoResultsError -> :error
      Ecto.StaleEntryError -> :error
      Ecto.NoPrimaryKeyValueError -> :error
      Ecto.Query.CastError -> :error
    end
  end

  @doc """
  Create a Model attribute.

  ## Examples

      iex> create_attribute(%CreateAttributeAttributes{
      ...>   model_id: "c8e47fc7-dee3-4c57-8955-9b49317f2af2",
      ...>   description: "The title of the book.",
      ...>   name: "title",
      ...>   kind: "string"
      ...>  })
      %Model{}

      iex> create_attribute(%CreateAttributeAttributes{})
      :error

  """
  @spec create_attribute(CreateAttributeAttributes.t()) :: Attribute.t() | :error
  def create_attribute(%CreateAttributeAttributes{} = attributes) do
    result =
      attributes
      |> Map.from_struct()
      |> Models.create_attribute()

    case result do
      {:ok, attribute} ->
        attribute

      {:error, _changset} ->
        :error
    end
  end

  @doc """
  Delete Model attribute by it's ID.

  Returns :ok if the Model attribute deleted, returns :error otherwise.

  ## Examples

      iex> delete_attribute("55d6e7cf-2de0-428c-bb19-9555d237e160")
      :ok

      iex> delete_attribute("55d6e7cf-2de0-428c-bb19-9555d237e161")
      :error

  """
  @spec delete_attribute(String.t()) :: :ok | :error
  def delete_attribute(id) do
    try do
      result =
        id
        |> Models.get_attribute!()
        |> Models.delete_attribute()

      case result do
        {:ok, _} ->
          :ok

        {:error, _changset} ->
          :error
      end
    rescue
      Ecto.NoResultsError -> :error
      Ecto.StaleEntryError -> :error
      Ecto.NoPrimaryKeyValueError -> :error
      Ecto.Query.CastError -> :error
    end
  end
end
