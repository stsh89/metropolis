defmodule Gymnasium.ModelsTest do
  use Gymnasium.DataCase

  alias Gymnasium.{Model, Models, Models}
  alias Gymnasium.Dimensions.{Project, Model, ModelAttribute, ModelAssociation}

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
      assert Models.list_attributes() == []
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

  describe "create model attribute" do
    test "create_attribute/1 saves Model's attribute" do
      %Model{id: model_id} = model_fixture()

      attrs = %{
        model_id: model_id,
        kind: "string",
        description: "The title of the Book.",
        name: "Title"
      }

      assert {:ok, %ModelAttribute{} = attribute} = Models.create_attribute(attrs)
      assert false == Models.list_attributes() |> Enum.empty?()

      assert attribute.model_id == model_id
      assert attribute.description == "The title of the Book."
      assert attribute.name == "Title"
    end

    test "create_attribute/1 returns error on invalid attrs" do
      assert {:error, %Ecto.Changeset{}} = Models.create_attribute(%{})
      assert true == Models.list_attributes() |> Enum.empty?()
    end

    test "create_attribute/1 returns error on missing name" do
      valid_attrs = %{
        model_id: Ecto.UUID.generate(),
        kind: "string",
        description: "The title of the book.",
        name: ""
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_attribute(valid_attrs)
      assert errors == [name: {"can't be blank", [validation: :required]}]
    end

    test "create_attribute/1 returns error on missing kind" do
      valid_attrs = %{
        model_id: Ecto.UUID.generate(),
        description: "The title of the book.",
        name: "Title"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_attribute(valid_attrs)
      assert errors == [kind: {"can't be blank", [validation: :required]}]
    end

    test "create_attribute/1 returns error on invalid kind" do
      valid_attrs = %{
        model_id: Ecto.UUID.generate(),
        description: "The title of the book.",
        name: "Title",
        kind: "color"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_attribute(valid_attrs)

      assert errors == [
               kind:
                 {"is invalid",
                  [{:validation, :inclusion}, {:enum, ["string", "integer", "boolean"]}]}
             ]
    end

    test "create_model/1 returns error on missing model_id" do
      attrs = %{
        description: "The title of the book.",
        name: "Title",
        kind: "string"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_attribute(attrs)
      assert errors == [model_id: {"can't be blank", [validation: :required]}]
    end

    test "create_attribute/1 returns error on existing model id and name pair" do
      %Model{id: model_id} = model_fixture()
      %ModelAttribute{name: name} = model_attribute_fixture(model_id: model_id)

      attrs = %{
        model_id: model_id,
        description: "Books model",
        name: name,
        kind: "string"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_attribute(attrs)

      assert errors == [
               model_id:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "model_attributes_model_id_name_index"]}
             ]
    end
  end

  describe "delete model attribute" do
    test "delete_attribute/1 removes a Model attribute" do
      attribute = model_attribute_fixture()

      assert {:ok, %ModelAttribute{}} = Models.delete_attribute(attribute)
      assert Models.list_attributes() == []
    end

    test "delete_attribute/1 raises Ecto.StaleEntryError" do
      assert_raise Ecto.StaleEntryError, fn ->
        Models.delete_attribute(%ModelAttribute{id: Ecto.UUID.generate()})
      end
    end
  end

  describe "create model association" do
    test "create_association/1 saves Model's association" do
      %Model{id: model_id} = model_fixture()
      %Model{id: associated_model_id} = model_fixture(name: "Author", slug: "author")

      attrs = %{
        model_id: model_id,
        associated_model_id: associated_model_id,
        kind: "belongs_to",
        description: "The author of the book",
        name: "Author"
      }

      assert {:ok, %ModelAssociation{} = association} = Models.create_association(attrs)
      assert false == Models.list_associations() |> Enum.empty?()

      assert association.model_id == model_id
      assert association.associated_model_id == associated_model_id
      assert association.description == "The author of the book"
      assert association.name == "Author"
      assert association.kind == "belongs_to"
    end

    test "create_association/1 returns error on invalid attrs" do
      assert {:error, %Ecto.Changeset{}} = Models.create_association(%{})
      assert true == Models.list_associations() |> Enum.empty?()
    end

    test "create_association/1 returns error on missing name" do
      attrs = %{
        model_id: Ecto.UUID.generate(),
        associated_model_id: Ecto.UUID.generate(),
        kind: "belongs_to",
        description: "The title of the book.",
        name: ""
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_association(attrs)
      assert errors == [name: {"can't be blank", [validation: :required]}]
    end

    test "create_association/1 returns error on missing kind" do
      attrs = %{
        model_id: Ecto.UUID.generate(),
        associated_model_id: Ecto.UUID.generate(),
        description: "The title of the book.",
        name: "Author"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_association(attrs)
      assert errors == [kind: {"can't be blank", [validation: :required]}]
    end

    test "create_association/1 returns error on invalid kind" do
      attrs = %{
        model_id: Ecto.UUID.generate(),
        associated_model_id: Ecto.UUID.generate(),
        description: "The title of the book.",
        name: "Author",
        kind: "many_to_many"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_association(attrs)

      assert errors == [
               kind:
                 {"is invalid",
                  [{:validation, :inclusion}, {:enum, ["belongs_to", "has_one", "has_many"]}]}
             ]
    end

    test "create_association/1 returns error on missing model_id" do
      attrs = %{
        associated_model_id: Ecto.UUID.generate(),
        description: "The title of the book.",
        name: "Author",
        kind: "belongs_to"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_association(attrs)
      assert errors == [model_id: {"can't be blank", [validation: :required]}]
    end

    test "create_association/1 returns error on missing associated_model_id" do
      attrs = %{
        model_id: Ecto.UUID.generate(),
        description: "The title of the book.",
        name: "Author",
        kind: "belongs_to"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_association(attrs)
      assert errors == [associated_model_id: {"can't be blank", [validation: :required]}]
    end

    test "create_association/1 returns error on existing model id and name pair" do
      %Model{id: model_id} = model_fixture()
      %ModelAssociation{name: name} = model_association_fixture(model_id: model_id)

      attrs = %{
        associated_model_id: Ecto.UUID.generate(),
        model_id: model_id,
        description: "The title of the book.",
        name: name,
        kind: "belongs_to"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Models.create_association(attrs)

      assert errors == [
               model_id:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "model_associations_model_id_name_index"]}
             ]
    end
  end

  describe "delete model association" do
    test "delete_association/1 removes a Model association" do
      association = model_association_fixture()

      assert {:ok, %ModelAssociation{}} = Models.delete_association(association)
      assert Models.list_associations() == []
    end

    test "delete_association/1 raises Ecto.StaleEntryError" do
      assert_raise Ecto.StaleEntryError, fn ->
        Models.delete_association(%ModelAssociation{id: Ecto.UUID.generate()})
      end
    end
  end
end
