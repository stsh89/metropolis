defmodule GymnasiumGrpc.ModelsServerTest do
  use Gymnasium.DataCase

  alias GymnasiumGrpc.ModelsServer
  alias Gymnasium.Dimensions.{Model, Project}

  alias Proto.Gymnasium.V1.Models.{
    CreateModelRequest,
    DeleteModelRequest,
    ListProjectModelsResponse,
    ListProjectModelsRequest,
    FindProjectModelRequest
  }

  import Gymnasium.{ModelsFixtures, ProjectsFixtures}

  alias Proto.Gymnasium.V1.Models.Model, as: ProtoModel

  describe "create the Model" do
    test "create_model/2 saves Model" do
      proto_model =
        ModelsServer.create_model(
          %CreateModelRequest{
            project_id: Ecto.UUID.generate(),
            name: "Book",
            slug: "book",
            description: ""
          },
          nil
        )

      assert %ProtoModel{name: name} = proto_model
      assert name == "Book"
    end

    test "create_model/2 returns error when request values are malformed" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        ModelsServer.create_model(
          %CreateModelRequest{},
          nil
        )
      end
    end
  end

  describe "Project models listing" do
    test "list_project_models/2 returns all models for given project slug" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      project_model = model_fixture(project_id: project_id)
      model_fixture(title: "Author", slug: "author")

      %ListProjectModelsResponse{models: list} =
        ModelsServer.list_project_models(
          %ListProjectModelsRequest{
            project_slug: project_slug
          },
          nil
        )

      assert_models(list, [project_model])
    end

    defp assert_models(list, expected_list) do
      assert Enum.map(list, fn m -> m.slug end) == Enum.map(expected_list, fn m -> m.slug end)
    end
  end

  describe "find Project's Model" do
    test "find_project_model/2 returns found Model" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      model_fixture(name: "Author")

      proto_model =
        ModelsServer.find_project_model(
          %FindProjectModelRequest{
            project_slug: project_slug,
            model_slug: model.slug
          },
          nil
        )

      assert model.name == proto_model.name
    end

    test "find_project_model/2 raises NotFound error" do
      assert_raise GRPC.RPCError,
                   "Project with the slug \"\" does not have a Model with the slug \"\".",
                   fn ->
                     ModelsServer.find_project_model(
                       %FindProjectModelRequest{
                         project_slug: "",
                         model_slug: ""
                       },
                       nil
                     )
                   end
    end
  end

  describe "delete Model by id" do
    test "delete_model/2 returns Google.Protobuf.Empty response" do
      %Model{id: id} = model_fixture()

      response =
        ModelsServer.delete_model(
          %DeleteModelRequest{
            id: id
          },
          nil
        )

      assert %Google.Protobuf.Empty{} == response
    end

    test "delete_model/2 raises internal error" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        ModelsServer.delete_model(
          %DeleteModelRequest{
            id: Ecto.UUID.generate()
          },
          nil
        )
      end
    end
  end
end
