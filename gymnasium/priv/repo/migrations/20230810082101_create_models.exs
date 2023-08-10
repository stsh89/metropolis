defmodule Gymnasium.Repo.Migrations.CreateModels do
  use Ecto.Migration

  def change do
    create table(:models) do
      add :description, :string
      add :name, :string
      add :slug, :string
      add :project_id, :uuid

      timestamps()
    end

    create table(:model_attributes) do
      add :description, :string
      add :name, :string
      add :kind, :string
      add :kind_value, :string
      add :list_indicator, :string
      add :model_id, :uuid

      timestamps()
    end

    create unique_index(:models, :name)
    create unique_index(:models, :slug)
    create unique_index(:model_attributes, :name)
    create index(:model_attributes, :model_id)
  end
end
