defmodule Gymnasium.Dimensions.Project do
  use Gymnasium.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
