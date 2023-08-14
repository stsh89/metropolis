defmodule Gymnasium.Dimensions.ModelAttribute do
  alias Gymnasium.Dimensions.Model

  use Gymnasium.Schema
  import Ecto.Changeset

  @list_indicators ["array", "not_a_list"]
  @kinds ["scalar", "reference"]
  @scalar_kinds ["string", "int64", "bool"]

  schema "model_attributes" do
    field :description, :string
    field :name, :string
    field :kind, :string
    field :kind_value, :string
    field :list_indicator, :string

    belongs_to :model, Model

    timestamps()
  end

  @doc false
  def changeset(model_attribute, attrs) do
    model_attribute
    |> cast(attrs, [:description, :name, :kind, :kind_value, :list_indicator, :model_id])
    |> validate_required([:name, :kind, :kind_value, :list_indicator])
    |> validate_inclusion(:kind, @kinds)
    |> validate_inclusion(:kind_value, @scalar_kinds)
    |> validate_inclusion(:list_indicator, @list_indicators)
    |> unique_constraint(:name, name: :model_attributes_name_index)
  end
end
