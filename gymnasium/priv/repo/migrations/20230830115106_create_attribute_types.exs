defmodule Gymnasium.Repo.Migrations.CreateAttributeTypes do
  use Ecto.Migration

  def change do
    create table(:attribute_types) do
      add :description, :string
      add :name, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:attribute_types, :name)
    create unique_index(:attribute_types, :slug)
  end
end
