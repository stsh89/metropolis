defmodule Gymnasium.Dimensions.Project do
  @type t() :: %__MODULE__{
          id: Ecto.UUID.t(),
          archived_at: Calendar.datetime() | nil,
          description: String.t(),
          name: String.t(),
          slug: String.t(),
          inserted_at: Calendar.datetime(),
          updated_at: Calendar.datetime()
        }

  alias Gymnasium.Dimensions.Model

  use Gymnasium.Schema
  import Ecto.Changeset

  schema "projects" do
    has_many :models, Model

    field :archived_at, :utc_datetime_usec

    field :description, :string

    field :name, :string

    field :slug, :string

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
