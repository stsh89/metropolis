defmodule Gymnasium.ModelsTest do
  use Gymnasium.DataCase

  alias Gymnasium.{Model, Models, Models}
  alias Gymnasium.Dimensions.{Project, Model}

  import Gymnasium.ModelsFixtures
  import Gymnasium.ProjectsFixtures

  describe "create a model" do
    test "create_model/1 saves Model" do
      %Project{id: project_id} = project_fixture()

      attrs = %{
        project_id: project_id,
        description: "Books model",
        name: "Book",
        slug: "book"
      }

      assert {:ok, %Model{} = model} = Models.create_model(attrs)
      assert false == Models.list_models() |> Enum.empty?()

      assert model.project_id == project_id
      assert model.description == "Books model"
      assert model.name == "Book"
      assert model.slug == "book"
    end

    test "create_model/1 returns error on invalid attrs" do
      assert {:error, %Ecto.Changeset{}} = Models.create_model(%{})
      assert true == Models.list_models() |> Enum.empty?()
    end

    test "create_model/1 returns error on missing name" do
      valid_attrs = %{
        project_id: Ecto.UUID.generate(),
        description: "Books model",
        name: "",
        slug: "book"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_model(valid_attrs)
      assert errors == [name: {"can't be blank", [validation: :required]}]
    end

    test "create_model/1 returns error on missing slug" do
      valid_attrs = %{
        project_id: Ecto.UUID.generate(),
        description: "Books model",
        name: "Book",
        slug: ""
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_model(valid_attrs)
      assert errors == [slug: {"can't be blank", [validation: :required]}]
    end

    test "create_model/1 returns error on missing project_id" do
      valid_attrs = %{
        description: "Books model",
        name: "Book",
        slug: "book"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_model(valid_attrs)
      assert errors == [project_id: {"can't be blank", [validation: :required]}]
    end

    test "create_model/1 returns error on existing project id and name pair" do
      %Project{id: project_id} = project_fixture()
      %Model{name: name} = model_fixture(project_id: project_id)

      valid_attrs = %{
        project_id: project_id,
        description: "Books model",
        name: name,
        slug: "some-slug"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_model(valid_attrs)

      assert errors == [
               project_id:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "models_project_id_name_index"]}
             ]
    end

    test "create_model/1 returns error on existing project id and slug pair" do
      %Project{id: project_id} = project_fixture()
      %Model{slug: slug} = model_fixture(project_id: project_id)

      attrs = %{
        project_id: project_id,
        description: "Books model",
        name: "Some name",
        slug: slug
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_model(attrs)

      assert errors == [
               project_id:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "models_project_id_slug_index"]}
             ]
    end
  end

  describe "delete model" do
    test "delete_model/1 removes a Model" do
      model = model_fixture()

      assert {:ok, %Model{}} = Models.delete_model!(model)
      assert Models.list_models() == []
    end

    test "delete_model/1 removes a Model with all associations" do
      model = model_fixture()
      associated_model = model_fixture(name: "Author", slug: "author")
      model_attribute_fixture(model_id: model.id)
      model_association_fixture(model_id: model.id, associated_model_id: associated_model.id)

      assert {:ok, %Model{}} = Models.delete_model!(model)
      assert Models.list_models() == [associated_model]
      assert Models.list_model_attributes() == []
      assert Models.list_associations() == []
    end

    test "delete_model/1 sets nil for associated models" do
      model = model_fixture()
      associated_model = model_fixture(name: "Author", slug: "author")
      model_attribute_fixture(model_id: model.id)

      association =
        model_association_fixture(model_id: model.id, associated_model_id: associated_model.id)

      assert {:ok, %Model{}} = Models.delete_model!(associated_model)
      assert Models.list_models() == [model]
      assert Models.list_associations() == [Map.put(association, :associated_model_id, nil)]
    end

    test "delete_model/1 raises Ecto.NoPrimaryKeyValueError" do
      assert_raise Ecto.NoPrimaryKeyValueError, fn ->
        Models.delete_model!(%Model{})
      end
    end

    test "delete_model/1 raises Ecto.StaleEntryError" do
      assert_raise Ecto.StaleEntryError, fn ->
        Models.delete_model!(%Model{id: Ecto.UUID.generate()})
      end
    end
  end
end
