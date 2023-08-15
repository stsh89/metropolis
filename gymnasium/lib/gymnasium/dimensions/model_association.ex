defmodule Gymnasium.Dimensions.ModelAssociation do
  alias Gymnasium.Dimensions.Model

  use Gymnasium.Schema
  import Ecto.Changeset

  @kinds ["belongs_to", "has_one", "has_many"]

  schema "model_associations" do
    belongs_to :model, Model

    belongs_to :associated_model, Model

    field :description, :string

    field :kind, :string

    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(model_attribute, attrs) do
    model_attribute
    |> cast(attrs, [:model_id, :associated_model_id, :description, :kind, :name])
    |> validate_required([:model_id, :associated_model_id, :kind, :name])
    |> validate_inclusion(:kind, @kinds)
    |> unique_constraint([:model_id, :name])
  end
end
