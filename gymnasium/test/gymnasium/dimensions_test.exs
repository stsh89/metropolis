defmodule Gymnasium.DimensionsTest do
  use Gymnasium.DataCase

  alias Gymnasium.Dimensions

  describe "dimensions" do
    alias Gymnasium.Dimensions.{Project, Model}

    import Gymnasium.DimensionsFixtures

    @invalid_project_attrs %{name: nil, slug: nil}
    @invalid_model_attrs %{name: nil, slug: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Dimensions.list_projects() == [project]
    end

    test "list_models/1 returns all models for the given project id" do
      project = project_fixture()
      model = model_fixture(project_id: project.id)

      assert Dimensions.list_models(project_id: project.id) == [model]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Dimensions.get_project!(project.id) == project
    end

    test "get_model!/1 returns the model with given id" do
      project = project_fixture()
      model = model_fixture(project_id: project.id)

      assert Dimensions.get_model!(model.id) == model
    end

    test "find_project!/1 returns the project with given slug" do
      project = project_fixture()
      assert Dimensions.find_project!(project.slug) == project
    end

    test "find_model!/3 returns the model with given slug" do
      project = project_fixture()
      model = model_fixture(project_id: project.id)

      assert Dimensions.find_model!(project.slug, model.slug) == model
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{
        description: "An online platform for buying and selling books.",
        name: "Bookstore",
        slug: "bookstore"
      }

      assert {:ok, %Project{} = project} = Dimensions.create_project(valid_attrs)
      assert project.description == "An online platform for buying and selling books."
      assert project.name == "Bookstore"
      assert project.slug == "bookstore"
    end

    test "create_model/1 with valid data creates a model" do
      project = project_fixture()

      valid_attrs = %{
        description: "Virtual book representation.",
        name: "Book",
        slug: "book",
        project_id: project.id
      }

      assert {:ok, %Model{} = model} = Dimensions.create_model(valid_attrs)
      assert model.description == "Virtual book representation."
      assert model.name == "Book"
      assert model.slug == "book"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dimensions.create_project(@invalid_project_attrs)
    end

    test "create_model/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dimensions.create_model(@invalid_model_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()

      update_attrs = %{
        description: "A wild sell and buy book platform",
        name: "Wild Bookstore",
        slug: "wild-bookstore"
      }

      assert {:ok, %Project{} = project} = Dimensions.update_project(project, update_attrs)
      assert project.name == "Wild Bookstore"
      assert project.description == "A wild sell and buy book platform"
      assert project.slug == "wild-bookstore"
    end

    test "update_model/2 with valid data updates the model" do
      project = project_fixture()
      model = model_fixture(project_id: project.id)

      update_attrs = %{
        description: "Author model",
        name: "Author",
        slug: "author"
      }

      assert {:ok, %Model{} = model} = Dimensions.update_model(model, update_attrs)
      assert model.name == "Author"
      assert model.description == "Author model"
      assert model.slug == "author"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Dimensions.update_project(project, @invalid_project_attrs)

      assert project == Dimensions.get_project!(project.id)
    end

    test "update_model/2 with invalid data returns error changeset" do
      project = project_fixture()
      model = model_fixture(project_id: project.id)

      assert {:error, %Ecto.Changeset{}} =
               Dimensions.update_model(model, @invalid_model_attrs)

      assert model == Dimensions.get_model!(model.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Dimensions.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Dimensions.get_project!(project.id) end
    end

    test "delete_model/1 deletes the model" do
      project = project_fixture()
      model = model_fixture(project_id: project.id)

      assert {:ok, %Model{}} = Dimensions.delete_model(model)
      assert_raise Ecto.NoResultsError, fn -> Dimensions.get_model!(model.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Dimensions.change_project(project)
    end

    test "change_model/1 returns a model changeset" do
      project = project_fixture()
      model = model_fixture(project_id: project.id)
      assert %Ecto.Changeset{} = Dimensions.change_model(model)
    end
  end
end