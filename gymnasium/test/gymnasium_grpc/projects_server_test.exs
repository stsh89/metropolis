defmodule GymnasiumGrpc.ProjectsServerTest do
  use Gymnasium.DataCase

  alias GymnasiumGrpc.ProjectsServer

  alias Proto.Gymnasium.V1.Projects.{
    ListProjectsRequest,
    ListProjectsResponse
  }

  describe "Projects listing" do
    import Gymnasium.ProjectsFixtures

    setup do
      archived_project = archived_project_fixture()
      project = project_fixture()

      [projects: {project, archived_project}]
    end

    test "list_projects/2 returns all projects when unspecified", context do
      expected_list = projects_list(context)

      %ListProjectsResponse{projects: list} =
        ProjectsServer.list_projects(
          %ListProjectsRequest{
            archive_state: :PROJECT_ARCHIVE_STATE_UNSPECIFIED
          },
          nil
        )

      assert_projects(list, expected_list)
    end

    test "list_projects/2 returns all projects when any", context do
      expected_list = projects_list(context)

      %ListProjectsResponse{projects: list} =
        ProjectsServer.list_projects(
          %ListProjectsRequest{
            archive_state: :PROJECT_ARCHIVE_STATE_ANY
          },
          nil
        )

      assert_projects(list, expected_list)
    end

    test "list_projects/2 returns only archived projects", context do
      expected_list = archived_projects_list(context)

      %ListProjectsResponse{projects: list} =
        ProjectsServer.list_projects(
          %ListProjectsRequest{
            archive_state: :PROJECT_ARCHIVE_STATE_ARCHIVED
          },
          nil
        )

      assert_projects(list, expected_list)
    end

    test "list_projects/2 returns only not archived projects", context do
      expected_list = not_archived_projects_list(context)

      %ListProjectsResponse{projects: list} =
        ProjectsServer.list_projects(
          %ListProjectsRequest{
            archive_state: :PROJECT_ARCHIVE_STATE_NOT_ARCHIVED
          },
          nil
        )

      assert_projects(list, expected_list)
    end

    defp assert_projects(list, expected_list) do
      assert Enum.map(list, fn p -> p.slug end) == Enum.map(expected_list, fn p -> p.slug end)
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
