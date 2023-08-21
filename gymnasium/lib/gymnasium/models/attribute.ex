defmodule Gymnasium.Models.Attribute do
  @moduledoc """
  Model attribute.
  """
  @type t() :: %__MODULE__{
          id: Ecto.UUID.t(),
          model_id: Ecto.UUID.t(),
          description: String.t(),
          kind: String.t(),
          name: String.t(),
          inserted_at: Calendar.datetime(),
          updated_at: Calendar.datetime()
        }

  alias Gymnasium.Models

  use Gymnasium.Schema
  import Ecto.Changeset

  @kinds ["string", "integer", "boolean"]

  schema "model_attributes" do
    belongs_to :model, Models.Model

    field :description, :string

    field :kind, :string

    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(model_attribute, attrs) do
    model_attribute
    |> cast(attrs, [:model_id, :description, :kind, :name])
    |> validate_required([:model_id, :kind, :name])
    |> validate_inclusion(:kind, @kinds)
    |> unique_constraint([:model_id, :name])
  end
end
