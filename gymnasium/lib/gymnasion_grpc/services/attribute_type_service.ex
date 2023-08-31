defmodule GymnasiumGrpc.AttributeTypeService do
  @moduledoc """
  Entrypoint for all actions around attribute types.
  """

  alias Gymnasium.AttributeTypes
  alias Gymnasium.AttributeTypes.AttributeType
  alias GymnasiumGrpc.AttributeTypeService.{CreateAttributeTypeAttributes}

  @doc """
  Create attribute type.

  ## Examples

      iex> create_attribute_type(%CreateAttributeTypeAttributes{name: "Bigint", slug: "bigint"})
      %AttributeType{}

  """
  @spec create_attribute_type(CreateAttributeTypeAttributes.t()) :: AttributeType.t()
  def create_attribute_type(%CreateAttributeTypeAttributes{} = attributes) do
    result =
      attributes
      |> Map.from_struct()
      |> AttributeTypes.create_attribute_type()

    case result do
      {:ok, attribute_type} ->
        attribute_type

      {:error, changeset} ->
        raise Ecto.InvalidChangesetError, action: :insert, changeset: changeset
    end
  end

  @doc """
  Find attribute type.

  ## Examples

      iex> find_attribute_type("bookstore")
      %AttributeType{}

  """
  @spec find_attribute_type(String.t()) :: AttributeType.t()
  def find_attribute_type(slug) do
    AttributeTypes.find_attribute_type!(slug)
  end

  @doc """
  Returns the list of attribute types.

  ## Examples

      iex> list_attribute_types()
      [%AttributeType{}, ...]

  """
  @spec list_attribute_types() :: [AttributeType.t()]
  def list_attribute_types() do
    AttributeTypes.list_attribute_types()
  end

  @doc """
  Update attribute type.

  ## Examples

      iex> update_attribute_type(%AttributeType{
      ...>   id: "29b5098f-abfa-45ed-9ff2-1e76ece9fe58",
      ...>   name: "Varchar",
      ...> }, ["name"])
      %AttributeType{}

  """
  @spec update_attribute_type(AttributeType.t(), [String]) :: AttributeType.t()
  def update_attribute_type(%AttributeType{} = attribute_type, update_mask) do
    attrs = build_update_attrs(attribute_type, update_mask)

    {:ok, attribute_type} =
      attribute_type.id
      |> AttributeTypes.get_attribute_type!()
      |> AttributeTypes.update_attribute_type(attrs)

    attribute_type
  end

  @doc """
  Delete attribute type.

  Returns :ok if the AttributeType deleted, returns :error otherwise.

  ## Examples

      iex> delete_attribute_type("b256b553-4ee9-4d61-acb9-e8eb4b009325")
      :ok

      iex> delete_attribute_type("dc35b24d-f155-4e59-ac69-500f820a2fcd")
      :error

  """
  @spec delete_attribute_type(Ecto.UUID.t()) :: {:ok, AttributeType.t()}
  def delete_attribute_type(id) do
    id
    |> AttributeTypes.get_attribute_type!()
    |> AttributeTypes.delete_attribute_type()
  end

  defp build_update_attrs(%AttributeType{} = attribute_type, update_mask) do
    Enum.reduce(update_mask, %{}, fn mask, acc ->
      if Enum.member?(["name", "slug", "description"], mask) do
        field_name = mask |> String.to_atom()
        Map.put(acc, field_name, Map.get(attribute_type, field_name))
      else
        acc
      end
    end)
  end
end
