defmodule GymnasiumGrpc.ModelServiceTest do
  use Gymnasium.DataCase

  alias GymnasiumGrpc.ModelService
  alias Gymnasium.Dimensions.{Project, Model}
  alias Gymnasium.{Projects, Models}
  alias GymnasiumGrpc.ModelService.{CreateModelAttributes, FindProjectModelAttributes}

  import Gymnasium.{ProjectsFixtures, ModelsFixtures}

  describe "crate a new Model" do
    test "create_model/1 saves project" do
      %Project{id: project_id} = project_fixture()

      attributes = %CreateModelAttributes{
        project_id: project_id,
        name: "Book store",
        slug: "book-store"
      }

      assert %Model{} = ModelService.create_model(attributes)
      assert false == Models.list_models() |> Enum.empty?()
    end

    test "create_model/1 does not save project with malformed arguments" do
      attributes = %CreateModelAttributes{
        name: "",
        slug: "book-store"
      }

      assert :error = ModelService.create_model(attributes)
      assert true == Projects.list_projects() |> Enum.empty?()
    end
  end

  describe "list project models" do
    test "list_project_models/1 returns all models for given project" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      model_fixture(name: "Food service", slug: "food-service")

      assert ModelService.list_project_models(project_slug) == [model]
    end
  end

  describe "find Project's Model" do
    test "find_project_model/1 returns found Model" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)

      attributes = %FindProjectModelAttributes{
        project_slug: project_slug,
        model_slug: model.slug
      }

      assert ModelService.find_project_model(attributes) == model
    end

    test "find_project_model/1 returns nil when Model is not found" do
      assert ModelService.find_project_model(%FindProjectModelAttributes{}) == nil
    end
  end

  describe "delete Model" do
    test "delete_model/1 returns :ok on successfull deletion" do
      %Model{id: id} = model_fixture()

      assert ModelService.delete_model(id) == :ok
      assert true == Models.list_models() |> Enum.empty?()
    end

    test "delete_model/1 returns :error on failed deletion" do
      assert ModelService.delete_model(Ecto.UUID.generate()) == :error
    end
  end
end
