defmodule Gymnasium.Dimensions.ModelAttribute do
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
