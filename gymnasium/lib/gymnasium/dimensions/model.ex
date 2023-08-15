defmodule Gymnasium.Dimensions.Model do
  alias Gymnasium.Dimensions.{Project, ModelAttribute, ModelAssociation}

  use Gymnasium.Schema
  import Ecto.Changeset

  schema "models" do
    belongs_to :project, Project

    has_many :associations, ModelAssociation

    has_many :attributes, ModelAttribute

    field :description, :string

    field :name, :string

    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:description, :name, :slug, :project_id])
    |> validate_required([:name, :slug, :project_id])
    |> unique_constraint([:project_id, :name])
    |> unique_constraint([:project_id, :slug])
  end
end
