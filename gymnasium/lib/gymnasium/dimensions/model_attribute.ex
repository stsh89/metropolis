defmodule Gymnasium.Dimensions.ModelAttribute do
  @type t() :: %__MODULE__{
          id: Ecto.UUID.t(),
          model_id: Ecto.UUID.t(),
          description: String.t(),
          kind: String.t(),
          name: String.t(),
          inserted_at: Calendar.datetime(),
          updated_at: Calendar.datetime()
        }

  alias Gymnasium.Dimensions.Model

  use Gymnasium.Schema
  import Ecto.Changeset

  @kinds ["string", "int64", "bool"]

  schema "model_attributes" do
    belongs_to :model, Model

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
