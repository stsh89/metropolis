defmodule Gymnasium.Repo.Migrations.CreateModels do
  use Ecto.Migration

  def change do
    create table(:models) do
      add :project_id, :uuid

      add :description, :string

      add :name, :string

      add :slug, :string

      timestamps()
    end

    create table(:model_associations) do
      add :model_id, :uuid

      add :associated_model_id, :uuid

      add :description, :string

      add :kind, :string

      add :name, :string

      timestamps()
    end

    create table(:model_attributes) do
      add :model_id, :uuid

      add :description, :string

      add :kind, :string

      add :name, :string

      timestamps()
    end

    create unique_index(:models, [:project_id, :name])

    create unique_index(:models, [:project_id, :slug])

    create unique_index(:model_associations, [:model_id, :name])

    create unique_index(:model_attributes, [:model_id, :name])
  end
end
