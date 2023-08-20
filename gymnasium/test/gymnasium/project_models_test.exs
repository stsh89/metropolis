defmodule Gymnasium.ModelsTest do
  use Gymnasium.DataCase

  alias Gymnasium.Dimensions.{Project}
  alias Gymnasium.ProjectModels

  import Gymnasium.ModelsFixtures
  import Gymnasium.ProjectsFixtures

  describe "list Project's Models" do
    test "list_project_models/1 returns all models for given Project slug" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      model_fixture(name: "Author", slug: "author")

      assert ProjectModels.list_project_models(project_slug) == [model]
    end
  end

  describe "finds Project's Model" do
    test "find_project_model/2 returns Project's model" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)

      assert ProjectModels.find_project_model!(project_slug, model.slug) == model
    end

    test "find_project_model/2 raises Ecto.NotFound error" do
      assert_raise Ecto.NoResultsError, fn -> ProjectModels.find_project_model!("", "") end
    end
  end
end
