defmodule Gymnasium.AttributeTypes do
  @moduledoc """
  The AttributeTypes context.
  """

  import Ecto.Query, warn: false
  alias Gymnasium.Repo

  alias Gymnasium.AttributeTypes.AttributeType

  @doc """
  Returns the list of attribute_types.

  ## Examples

      iex> list_attribute_types()
      [%AttributeType{}, ...]

  """
  @spec list_attribute_types() :: [AttributeType.t()]
  def list_attribute_types do
    Repo.all(AttributeType)
  end

  @doc """
  Gets a single attribute_type.

  Raises `Ecto.NoResultsError` if the Attribute type does not exist.

  ## Examples

      iex> get_attribute_type!("b256b553-4ee9-4d61-acb9-e8eb4b009325")
      %AttributeType{}

      iex> get_attribute_type!("dc35b24d-f155-4e59-ac69-500f820a2fcd")
      ** (Ecto.NoResultsError)

  """
  @spec get_attribute_type!(Ecto.Uuid.t()) :: AttributeType.t()
  def get_attribute_type!(id), do: Repo.get!(AttributeType, id)

  @doc """
  Finds a single attribute_type.

  Raises `Ecto.NoResultsError` if the Attribute type does not exist.

  ## Examples

      iex> find_attribute_type!("bigint")
      %AttributeType{}

      iex> find_attribute_type!("varchar")
      ** (Ecto.NoResultsError)

  """
  @spec find_attribute_type!(String.t()) :: AttributeType.t()
  def find_attribute_type!(slug), do: Repo.get_by!(AttributeType, slug: slug)

  @doc """
  Creates a attribute_type.

  ## Examples

      iex> create_attribute_type(%{field: value})
      {:ok, %AttributeType{}}

      iex> create_attribute_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_attribute_type(map()) :: {:ok, AttributeType.t()} | {:error, Ecto.Changeset.t()}
  def create_attribute_type(attrs \\ %{}) do
    %AttributeType{}
    |> AttributeType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attribute_type.

  ## Examples

      iex> update_attribute_type(attribute_type, %{field: new_value})
      {:ok, %AttributeType{}}

      iex> update_attribute_type(attribute_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_attribute_type(AttributeType.t(), map()) ::
          {:ok, AttributeType.t()} | {:error, Ecto.Changeset.t()}
  def update_attribute_type(%AttributeType{} = attribute_type, attrs) do
    attribute_type
    |> AttributeType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a attribute_type.

  ## Examples

      iex> delete_attribute_type(attribute_type)
      {:ok, %AttributeType{}}

      iex> delete_attribute_type(attribute_type)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_attribute_type(AttributeType.t()) :: {:ok, AttributeType.t()}
  def delete_attribute_type(%AttributeType{} = attribute_type) do
    Repo.delete(attribute_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attribute_type changes.

  ## Examples

      iex> change_attribute_type(attribute_type)
      %Ecto.Changeset{data: %AttributeType{}}

  """
  @spec change_attribute_type(AttributeType.t(), map()) :: Ecto.Changeset.t()
  def change_attribute_type(%AttributeType{} = attribute_type, attrs \\ %{}) do
    AttributeType.changeset(attribute_type, attrs)
  end
end
