defmodule GymnasiumGrpc.ProjectServiceTest do
  use Gymnasium.DataCase

  alias GymnasiumGrpc.ProjectService
  alias Gymnasium.Projects.Project
  alias Gymnasium.Projects
  alias GymnasiumGrpc.ProjectService.{CreateProjectAttributes, RenameProjectAttributes}

  import Gymnasium.ProjectsFixtures

  describe "crate a new Project" do
    test "create_project/1 saves project" do
      attributes = %CreateProjectAttributes{
        name: "Book store",
        slug: "book-store"
      }

      assert %Project{} = ProjectService.create_project(attributes)
      assert false == Projects.list_projects() |> Enum.empty?()
    end

    test "create_project/1 does not save project with malformed arguments" do
      attributes = %CreateProjectAttributes{
        name: "",
        slug: "book-store"
      }

      assert :error = ProjectService.create_project(attributes)
      assert true == Projects.list_projects() |> Enum.empty?()
    end
  end

  describe "rename a Project" do
    setup do
      project = project_fixture()

      [project: project]
    end

    test "rename_project/1 updates project's name and slug", context do
      project = context[:project]

      attributes = %RenameProjectAttributes{
        id: project.id,
        name: "Food service",
        slug: "food-service"
      }

      assert %Project{} = ProjectService.rename_project(attributes)
      assert %Project{name: name, slug: slug} = Projects.get_project!(project.id)
      assert name == "Food service"
      assert slug == "food-service"
    end

    test "rename_project/1 does not update project with malformed arguments", context do
      project = context[:project]

      attributes = %RenameProjectAttributes{
        id: project.id,
        name: "",
        slug: "food-service"
      }

      assert :error = ProjectService.rename_project(attributes)
      assert %Project{name: name, slug: slug} = Projects.get_project!(project.id)
      assert name == project.name
      assert slug == project.slug
    end

    test "rename_project/1 does not update project with empty id", context do
      project = context[:project]

      attributes = %RenameProjectAttributes{
        id: "",
        name: "Food service",
        slug: "food-service"
      }

      assert :error = ProjectService.rename_project(attributes)
      assert %Project{name: name, slug: slug} = Projects.get_project!(project.id)
      assert name == project.name
      assert slug == project.slug
    end
  end

  describe "filter projects by archive state" do
    setup do
      archived_project = archived_project_fixture()
      project = project_fixture()

      [projects: {project, archived_project}]
    end

    test "list_projects/0 returns all projects", context do
      list = projects_list(context)

      assert ProjectService.list_projects() == list
    end

    test "list_projects/1 returns only archived projects", context do
      list = archived_projects_list(context)

      assert ProjectService.list_projects(archive_state: :archived_only) == list
    end

    test "list_projects/1 returns only not archived projects", context do
      list = not_archived_projects_list(context)

      assert ProjectService.list_projects(archive_state: :not_archived_only) == list
    end

    test "list_projects/1 with malformed params returns all projects", context do
      list = projects_list(context)

      assert ProjectService.list_projects(archive_state: :malformed) == list
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

  describe "find Project by slug" do
    test "find_project/1 returns found Project" do
      project = %Project{slug: slug} = project_fixture()

      assert ProjectService.find_project(slug) == project
    end

    test "find_project/1 returns nil when Project is not found" do
      assert ProjectService.find_project("") == nil
    end
  end

  describe "delete Project" do
    test "delete_project/1 returns :ok on successfull deletion" do
      %Project{id: id} = project_fixture()

      assert ProjectService.delete_project(id) == :ok
      assert true == Projects.list_projects() |> Enum.empty?()
    end

    test "find_project/1 returns :error on failed deletion" do
      assert ProjectService.delete_project(Ecto.UUID.generate()) == :error
    end
  end

  describe "archive Project" do
    test "archive_project/1 returns :ok on successfull archivation" do
      %Project{id: id} = project_fixture()

      assert ProjectService.archive_project(id) == :ok
      assert true == Projects.list_projects(not_archived_only: true) |> Enum.empty?()
    end

    test "archive_project/1 returns :error on failed archivation" do
      assert ProjectService.archive_project(Ecto.UUID.generate()) == :error
    end
  end

  describe "restore Project" do
    test "restore_project/1 returns :ok on successfull restoration" do
      %Project{id: id} = archived_project_fixture()

      assert ProjectService.restore_project(id) == :ok
      assert true == Projects.list_projects(archived_only: true) |> Enum.empty?()
    end

    test "restore_project/1 returns :error on failed restoration" do
      assert ProjectService.restore_project(Ecto.UUID.generate()) == :error
    end
  end
end
