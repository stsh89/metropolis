defmodule Gymnasium.Repo.Migrations.AddAttributeTypeIdToModelAttributes do
  use Ecto.Migration

  def change do
    alter table("model_attributes") do
      add :attribute_type_id, :uuid
      remove :kind, :string
    end

    create index(:model_attributes, :attribute_type_id)
  end
end
