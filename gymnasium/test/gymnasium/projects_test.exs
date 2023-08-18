defmodule Gymnasium.ProjectsTest do
  use Gymnasium.DataCase

  alias Gymnasium.Projects

  describe "filter projects by `archived_at` field`" do
    import Gymnasium.ProjectsFixtures

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
end
