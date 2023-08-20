defmodule GymnasiumGrpc.ProjectsServerTest do
  use Gymnasium.DataCase

  alias GymnasiumGrpc.ProjectsServer

  alias Proto.Gymnasium.V1.Projects.{
    ArchiveProjectRequest,
    CreateProjectRequest,
    DeleteProjectRequest,
    FindProjectRequest,
    ListProjectsRequest,
    ListProjectsResponse,
    RestoreProjectRequest
  }

  alias Proto.Gymnasium.V1.Projects.Project, as: ProtoProject

  alias Gymnasium.Dimensions.Project

  import Gymnasium.ProjectsFixtures

  describe "create the Project" do
    test "create_project/2 saves Project" do
      proto_project =
        ProjectsServer.create_project(
          %CreateProjectRequest{
            name: "Book store",
            slug: "book-store",
            description: "Buy and sell books platform."
          },
          nil
        )

      assert %ProtoProject{name: name} = proto_project
      assert name == "Book store"
    end

    test "create_project/2 returns error when request values are malformed" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        ProjectsServer.create_project(
          %CreateProjectRequest{
            name: "",
            slug: ""
          },
          nil
        )
      end
    end
  end

  describe "find Project by slug" do
    test "find_project/2 returns found Project" do
      %Project{slug: slug, name: name} = project_fixture()

      proto_project =
        ProjectsServer.find_project(
          %FindProjectRequest{
            slug: slug
          },
          nil
        )

      assert name == proto_project.name
    end

    test "find_project/2 raises NotFound error" do
      assert_raise GRPC.RPCError, "Project with the slug \"\" was not found.", fn ->
        ProjectsServer.find_project(
          %FindProjectRequest{
            slug: ""
          },
          nil
        )
      end
    end
  end

  describe "Projects listing" do
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

  describe "delete Project by id" do
    test "delete_project/2 returns Google.Protobuf.Empty response" do
      %Project{id: id} = project_fixture()

      response =
        ProjectsServer.delete_project(
          %DeleteProjectRequest{
            id: id
          },
          nil
        )

      assert %Google.Protobuf.Empty{} == response
    end

    test "delete_project/2 raises internal error" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        ProjectsServer.delete_project(
          %DeleteProjectRequest{
            id: Ecto.UUID.generate()
          },
          nil
        )
      end
    end
  end

  describe "archive Project by id" do
    test "archive_project/2 returns Google.Protobuf.Empty response" do
      %Project{id: id} = project_fixture()

      response =
        ProjectsServer.archive_project(
          %ArchiveProjectRequest{
            id: id
          },
          nil
        )

      assert %Google.Protobuf.Empty{} == response
    end

    test "archive_project/2 raises internal error" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        ProjectsServer.archive_project(
          %ArchiveProjectRequest{
            id: Ecto.UUID.generate()
          },
          nil
        )
      end
    end
  end

  describe "restore Project by id" do
    test "restore_project/2 returns Google.Protobuf.Empty response" do
      %Project{id: id} = archived_project_fixture()

      response =
        ProjectsServer.restore_project(
          %RestoreProjectRequest{
            id: id
          },
          nil
        )

      assert %Google.Protobuf.Empty{} == response
    end

    test "restore_project/2 raises internal error" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        ProjectsServer.restore_project(
          %RestoreProjectRequest{
            id: Ecto.UUID.generate()
          },
          nil
        )
      end
    end
  end
end
