defmodule GymnasiumGrpc.ProjectServiceTest do
  use Gymnasium.DataCase

  alias GymnasiumGrpc.ProjectService
  alias Gymnasium.Dimensions.Project

  import Gymnasium.ProjectsFixtures

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
    end

    test "find_project/1 returns :error on failed deletion" do
      assert ProjectService.delete_project("") == :error
    end
  end
end
