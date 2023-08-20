defmodule Gymnasium.ProjectsTest do
  use Gymnasium.DataCase

  alias Gymnasium.{Projects, Models}
  alias Gymnasium.Dimensions.Project

  import Gymnasium.ProjectsFixtures
  import Gymnasium.ModelsFixtures

  describe "create a project" do
    test "create_project/1 saves Project" do
      valid_attrs = %{
        description: "An online platform for buying and selling books.",
        name: "Bookstore",
        slug: "bookstore"
      }

      assert {:ok, %Project{} = project} = Projects.create_project(valid_attrs)
      assert false == Projects.list_projects() |> Enum.empty?()

      assert project.description == "An online platform for buying and selling books."
      assert project.name == "Bookstore"
      assert project.slug == "bookstore"
    end

    test "create_project/1 returns error on missing name" do
      valid_attrs = %{
        description: "An online platform for buying and selling books.",
        name: "",
        slug: "some-slug"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Projects.create_project(valid_attrs)
      assert errors == [name: {"can't be blank", [validation: :required]}]
      assert true == Projects.list_projects() |> Enum.empty?()
    end

    test "create_project/1 returns error on missing slug" do
      valid_attrs = %{
        description: "An online platform for buying and selling books.",
        name: "Some name",
        slug: ""
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Projects.create_project(valid_attrs)
      assert errors == [slug: {"can't be blank", [validation: :required]}]
      assert true == Projects.list_projects() |> Enum.empty?()
    end

    test "create_project/1 returns error on existing name" do
      project = %Project{name: name} = project_fixture()

      valid_attrs = %{
        description: "An online platform for buying and selling books.",
        name: name,
        slug: "some-slug"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Projects.create_project(valid_attrs)

      assert errors == [
               name:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "projects_name_index"]}
             ]

      assert [project] == Projects.list_projects()
    end

    test "create_project/1 returns error on existing slug" do
      project = %Project{slug: slug} = project_fixture()

      valid_attrs = %{
        description: "An online platform for buying and selling books.",
        name: "Some name",
        slug: slug
      }

      assert {:error, %Ecto.Changeset{errors: errors}} = Projects.create_project(valid_attrs)

      assert errors == [
               slug:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "projects_slug_index"]}
             ]

      assert [project] == Projects.list_projects()
    end
  end

  describe "filter projects by `archived_at` field`" do
    setup do
      archived_project = archived_project_fixture()
      project = project_fixture()

      [projects: {project, archived_project}]
    end

    test "list_projects/0 returns all projects", context do
      list = projects_list(context)

      assert Projects.list_projects() == list
    end

    test "list_projects/1 returns only archived projects", context do
      list = archived_projects_list(context)

      assert Projects.list_projects(archived_only: true) == list
    end

    test "list_projects/1 returns only not archived projects", context do
      list = not_archived_projects_list(context)

      assert Projects.list_projects(not_archived_only: true) == list
    end

    defp projects_list(context) do
      context
      |> Map.get(:projects)
      |> Tuple.to_list()
    end

    defp archived_projects_list(context) do
      context
      |> projects_list()
      |> Enum.filter(fn p -> p.archived_at != nil end)
    end

    defp not_archived_projects_list(context) do
      context
      |> projects_list()
      |> Enum.filter(fn p -> p.archived_at == nil end)
    end
  end

  describe "get a single Project by it's slug" do
    test "find_project/1 returns single Project" do
      project = %Project{slug: slug} = project_fixture()

      assert Projects.find_project!(slug) == project
    end

    test "find_project/1 raises error when Project is not found" do
      assert_raise Ecto.NoResultsError, fn -> Projects.find_project!("") end
    end
  end

  describe "delete project" do
    test "delete_project/1 removes a Project" do
      project = project_fixture()

      assert {:ok, %Project{}} = Projects.delete_project!(project)
      assert Projects.list_projects() == []
    end

    test "delete_project/1 removes a Project with all associations" do
      project = project_fixture()
      model = model_fixture(project_id: project.id)
      associated_model = model_fixture(project_id: project.id, name: "Author", slug: "author")
      model_attribute_fixture(model_id: model.id)
      model_association_fixture(model_id: model.id, associated_model_id: associated_model.id)

      assert {:ok, %Project{}} = Projects.delete_project!(project)
      assert Projects.list_projects() == []
      assert Models.list_models() == []
      assert Models.list_model_attributes() == []
      assert Models.list_model_associations() == []
    end

    test "delete_project/1 raises Ecto.NoPrimaryKeyValueError" do
      assert_raise Ecto.NoPrimaryKeyValueError, fn ->
        Projects.delete_project!(%Project{})
      end
    end

    test "delete_project/1 raises Ecto.StaleEntryError" do
      assert_raise Ecto.StaleEntryError, fn ->
        Projects.delete_project!(%Project{id: Ecto.UUID.generate()})
      end
    end
  end

  describe "archive a project" do
    test "archive_project/1 sets archivation timestamp" do
      project = project_fixture()

      assert {:ok, %Project{} = archived_project} = Projects.archive_project(project)
      assert archived_project.archived_at != nil
    end

    test "archive_project/1 updates archivation timestamp" do
      archived_project = archived_project_fixture()

      assert {:ok, %Project{} = rearchived_project} = Projects.archive_project(archived_project)
      assert DateTime.compare(rearchived_project.archived_at, archived_project.archived_at) == :gt
    end
  end

  describe "restore a project" do
    test "restore_project/1 removes archivation timestamp" do
      archived_project = archived_project_fixture()

      assert {:ok, %Project{} = project} = Projects.restore_project(archived_project)
      assert project.archived_at == nil
    end

    test "archive_project/1 does nothing for project" do
      project = project_fixture()

      assert {:ok, updated_project} = Projects.restore_project(project)
      assert updated_project == project
    end
  end
end
