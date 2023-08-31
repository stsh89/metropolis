defmodule Gymnasium.AttributeTypes.AttributeType do
  @moduledoc """
  Attribute type
  """

  @type t() :: %__MODULE__{
          id: Ecto.UUID.t(),
          description: String.t(),
          name: String.t(),
          slug: String.t(),
          inserted_at: Calendar.datetime(),
          updated_at: Calendar.datetime()
        }

  use Gymnasium.Schema
  import Ecto.Changeset

  schema "attribute_types" do
    field :name, :string
    field :description, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(attribute_type, attrs) do
    attribute_type
    |> cast(attrs, [:description, :name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint(:name, name: :attribute_types_name_index)
    |> unique_constraint(:slug, name: :attribute_types_slug_index)
  end
end
