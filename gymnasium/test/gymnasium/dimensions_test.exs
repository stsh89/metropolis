defmodule Gymnasium.DimensionsTest do
  use Gymnasium.DataCase

  alias Gymnasium.Dimensions

  describe "dimensions" do
    alias Gymnasium.Dimensions.Project

    import Gymnasium.DimensionsFixtures

    @invalid_project_attrs %{name: nil, slug: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Dimensions.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Dimensions.get_project!(project.id) == project
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

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dimensions.create_project(@invalid_project_attrs)
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
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Dimensions.update_project(project, @invalid_project_attrs)
      assert project == Dimensions.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Dimensions.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Dimensions.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Dimensions.change_project(project)
    end
  end
end
