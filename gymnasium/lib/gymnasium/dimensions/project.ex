defmodule Gymnasium.Dimensions.Project do
  alias Gymnasium.Dimensions.Model

  use Gymnasium.Schema
  import Ecto.Changeset

  schema "projects" do
    field :description, :string
    field :name, :string
    field :slug, :string
    field :archived_at, :utc_datetime_usec

    has_many :models, Model

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:description, :name, :slug, :archived_at])
    |> validate_required([:name, :slug])
    |> unique_constraint(:name, name: :projects_name_index)
    |> unique_constraint(:slug, name: :projects_slug_index)
  end

  @doc false
  def archive_changeset(project) do
    project
    |> change(archived_at: DateTime.utc_now())
  end

  @doc false
  def restore_changeset(project) do
    project
    |> change(archived_at: nil)
  end
end
