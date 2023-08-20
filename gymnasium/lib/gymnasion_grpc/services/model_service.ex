defmodule GymnasiumGrpc.ModelService do
  alias Gymnasium.{Models, ProjectModels}
  alias Gymnasium.Dimensions.Model
  alias GymnasiumGrpc.ModelService.{CreateModelAttributes, FindProjectModelAttributes}

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
end
