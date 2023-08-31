defmodule Gymnasium.Models.Attribute do
  @moduledoc """
  Model attribute.
  """
  @type t() :: %__MODULE__{
          id: Ecto.UUID.t(),
          model_id: Ecto.UUID.t(),
          description: String.t(),
          attribute_type_id: Ecto.UUID.t(),
          name: String.t(),
          inserted_at: Calendar.datetime(),
          updated_at: Calendar.datetime()
        }

  alias Gymnasium.{Models, AttributeTypes}

  use Gymnasium.Schema
  import Ecto.Changeset

  schema "model_attributes" do
    belongs_to :model, Models.Model

    belongs_to :attribute_type, AttributeTypes.AttributeType

    field :description, :string

    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(model_attribute, attrs) do
    model_attribute
    |> cast(attrs, [:model_id, :attribute_type_id, :name, :description])
    |> validate_required([:attribute_type_id, :model_id, :name])
    |> unique_constraint([:model_id, :name])
  end
end
