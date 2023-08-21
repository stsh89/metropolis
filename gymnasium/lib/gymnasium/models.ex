defmodule Gymnasium.Models do
  @moduledoc """
  The Models context.
  """

  import Ecto.Query, warn: false

  alias Gymnasium.Models.{Model, Attribute, Association}
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
  Gets a single model association.

  Raises `Ecto.NoResultsError` if the model association does not exist.

  ## Examples

      iex> get_association!("8e3b5275-bc1b-4490-a2d8-23c68d9b0fd5")
      %Association{}

      iex> get_association!("8844f7c8-1f83-4fdf-817f-41780c9e5d05")
      ** (Ecto.NoResultsError)

  """
  @spec get_association!(String.t()) :: Association.t()
  def get_association!(id), do: Repo.get!(Association, id)

  @doc """
  Gets a single model attribute.

  Raises `Ecto.NoResultsError` if the Model attribute does not exist.

  ## Examples

      iex> get_attribute!("8e3b5275-bc1b-4490-a2d8-23c68d9b0fd5")
      %Model_Attribute{}

      iex> get_attribute!("8844f7c8-1f83-4fdf-817f-41780c9e5d05")
      ** (Ecto.NoResultsError)

  """
  @spec get_attribute!(String.t()) :: Attribute.t()
  def get_attribute!(id), do: Repo.get!(Attribute, id)

  @doc """
  Creates a model.

  ## Examples

      iex> create_model(%{field: value})
      {:ok, %Model{}}

      iex> create_model(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_model(map()) :: {:ok, Model.t()} | {:error, Ecto.Changeset.t()}
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
  @spec create_model(map()) :: {:ok, Attribute.t()} | {:error, Ecto.Changeset.t()}
  def create_attribute(attrs \\ %{}) do
    %Attribute{}
    |> Attribute.changeset(attrs)
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
        Repo.all(from ma in Association, where: ma.model_id == ^model.id, select: ma.id)
      end

    model_attribute_ids =
      if model.id == nil do
        []
      else
        Repo.all(from ma in Attribute, where: ma.model_id == ^model.id, select: ma.id)
      end

    Repo.transaction(fn ->
      Repo.delete_all(from ma in Association, where: ma.id in ^model_association_ids)
      Repo.delete_all(from ma in Attribute, where: ma.id in ^model_attribute_ids)

      if model.id != nil do
        from(ma in Association,
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

  ## Examples

      iex> delete_attribute(model)
      {:ok, %Attribute{}}

      iex> delete_attribute(model)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_attribute(Attribute.t()) ::
          {:ok, Attribute.t()} | {:error, Ecto.Changeset.t()}
  def delete_attribute(%Attribute{} = attribute) do
    Repo.delete(attribute)
  end

  @doc """
  Deletes a Model association.

  ## Examples

      iex> delete_association(model)
      {:ok, %Association{}}

      iex> delete_association(model)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_association(Association.t()) ::
          {:ok, Association.t()} | {:error, Ecto.Changeset.t()}
  def delete_association(%Association{} = association) do
    Repo.delete(association)
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
      [%Attribute{}, ...]

  """
  @spec list_attributes() :: [Attribute.t()]
  def list_attributes() do
    query = from m in Attribute, order_by: [asc: m.name]

    Repo.all(query)
  end

  @doc """
  Returns the list of model associations.

  ## Examples

      iex> list_associations()
      [%Association{}, ...]

  """
  @spec list_models() :: [Association.t()]
  def list_associations() do
    query = from m in Association, order_by: [asc: m.name]

    Repo.all(query)
  end

  @doc """
  Creates a model association.

  ## Examples

      iex> create_association(%{field: value})
      {:ok, %model{}}

      iex> create_association(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_association(attrs \\ %{}) do
    %Association{}
    |> Association.changeset(attrs)
    |> Repo.insert()
  end
end
