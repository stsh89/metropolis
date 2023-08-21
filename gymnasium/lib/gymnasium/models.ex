defmodule Gymnasium.Models do
  @moduledoc """
  The Models context.
  """

  import Ecto.Query, warn: false

  alias Gymnasium.Dimensions.{Model, ModelAttribute, ModelAssociation}
  alias Gymnasium.Repo

  @doc """
  Gets a single model.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_model!("8e3b5275-bc1b-4490-a2d8-23c68d9b0fd5")
      %Project{}

      iex> get_model!("8844f7c8-1f83-4fdf-817f-41780c9e5d05")
      ** (Ecto.NoResultsError)

  """
  @spec get_model!(String.t()) :: Model.t()
  def get_model!(id), do: Repo.get!(Model, id)

  @doc """
  Creates a model.

  ## Examples

      iex> create_model(%{field: value})
      {:ok, %Model{}}

      iex> create_model(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_model(map()) :: {:ok, Model.t()} | {:error, %Ecto.Changeset{}}
  def create_model(attrs \\ %{}) do
    %Model{}
    |> Model.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a model attribute.

  ## Examples

      iex> create_attribute(%{field: value})
      {:ok, %model{}}

      iex> create_attribute(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_model(map()) :: {:ok, ModelAttribute.t()} | {:error, %Ecto.Changeset{}}
  def create_attribute(attrs \\ %{}) do
    %ModelAttribute{}
    |> ModelAttribute.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Model.

  Returns the struct or raises some Ecto error.

  ## Examples

      iex> delete_model!(model)
      %Model{}

      iex> delete_model!(model)
      ** (Ecto.NoResultsError)

  """
  @spec delete_model!(Model.t()) :: {:ok, Model.t()}
  def delete_model!(%Model{} = model) do
    model_association_ids =
      if model.id == nil do
        []
      else
        Repo.all(from ma in ModelAssociation, where: ma.model_id == ^model.id, select: ma.id)
      end

    model_attribute_ids =
      if model.id == nil do
        []
      else
        Repo.all(from ma in ModelAttribute, where: ma.model_id == ^model.id, select: ma.id)
      end

    Repo.transaction(fn ->
      Repo.delete_all(from ma in ModelAssociation, where: ma.id in ^model_association_ids)
      Repo.delete_all(from ma in ModelAttribute, where: ma.id in ^model_attribute_ids)

      if model.id != nil do
        from(ma in ModelAssociation,
          where: ma.associated_model_id == ^model.id,
          update: [set: [associated_model_id: nil]]
        )
        |> Repo.update_all([])
      end

      Repo.delete!(model)
    end)
  end

  @doc """
  Deletes a Model attribute.

  Returns the struct or raises some Ecto error.

  ## Examples

      iex> delete_attribute(model)
      {:ok, %ModelAttribute{}}

      iex> delete_attribute(model)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_attribute(ModelAttribute.t()) ::
          {:ok, ModelAttribute.t()} | {:error, Ecto.Changeset.t()}
  def delete_attribute(%ModelAttribute{} = attribute) do
    Repo.delete(attribute)
  end

  @doc """
  Returns the list of models.

  ## Examples

      iex> list_models()
      [%Model{}, ...]

  """
  @spec list_models() :: [Model.t()]
  def list_models() do
    query = from m in Model, order_by: [asc: m.name]

    Repo.all(query)
  end

  @doc """
  Returns the list of model attributes.

  ## Examples

      iex> list_attributes()
      [%ModelAttribute{}, ...]

  """
  @spec list_attributes() :: [ModelAttribute.t()]
  def list_attributes() do
    query = from m in ModelAttribute, order_by: [asc: m.name]

    Repo.all(query)
  end

  @doc """
  Returns the list of model associations.

  ## Examples

      iex> list_associations()
      [%ModelAssociation{}, ...]

  """
  @spec list_models() :: [ModelAssociation.t()]
  def list_associations() do
    query = from m in ModelAssociation, order_by: [asc: m.name]

    Repo.all(query)
  end

  @doc """
  Creates a model association.

  ## Options

      * `:preload_associated_model` - return Model association with preloaded
      associated Model.

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

    model_association =
      if attrs[:preload_associated_model] do
        Repo.preload(model_association, :associated_model)
      else
        model_association
      end

    {:ok, model_association}
  end
end
