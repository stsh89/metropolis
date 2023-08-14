defmodule Gymnasium.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :archived_at, :utc_datetime_usec

      add :description, :string

      add :name, :string

      add :slug, :string

      timestamps()
    end

    create unique_index(:projects, :name)
    create unique_index(:projects, :slug)
  end
end
