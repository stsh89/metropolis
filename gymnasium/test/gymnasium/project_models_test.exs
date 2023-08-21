defmodule Gymnasium.ProjectModelsTest do
  use Gymnasium.DataCase

  alias Gymnasium.Dimensions.{Project, Model}
  alias Gymnasium.ProjectModels

  import Gymnasium.ModelsFixtures
  import Gymnasium.ProjectsFixtures

  describe "find Project's Model" do
    test "find_project_model/2 returns Project's model" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)

      assert ProjectModels.find_project_model!(project_slug, model.slug) == model
    end

    test "find_project_model/2 raises Ecto.NotFound error" do
      assert_raise Ecto.NoResultsError, fn -> ProjectModels.find_project_model!("", "") end
    end
  end

  describe "list Project's Models" do
    test "list_project_models/1 returns all models for given Project slug" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      model_fixture(name: "Author", slug: "author")

      assert ProjectModels.list_project_models(project_slug) == [model]
    end
  end

  describe "find Project's Model attribute" do
    test "find_project_model_attribute/3 returns Project's model attribute" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      attribute = model_attribute_fixture(model_id: model.id)

      assert ProjectModels.find_project_model_attribute!(project_slug, model.slug, attribute.name) ==
               attribute
    end

    test "find_project_model_attribute/3 raises Ecto.NotFound error" do
      assert_raise Ecto.NoResultsError, fn ->
        ProjectModels.find_project_model_attribute!("", "", "")
      end
    end
  end

  describe "list Project's Model's attributes" do
    test "list_project_model_attributes/2 returns all model's attributes" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      %Model{id: model_id, slug: model_slug} = model_fixture(project_id: project_id)
      attribute = model_attribute_fixture(model_id: model_id)
      model_attribute_fixture()

      assert ProjectModels.list_project_model_attributes(project_slug, model_slug) == [attribute]
    end
  end

  describe "finds Project's Model association" do
    test "find_project_model_association/3 returns Project's model association" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      associated_model = model_fixture(project_id: project_id, name: "Aurhor", slug: "author")

      association =
        model_association_fixture(model_id: model.id, associated_model_id: associated_model.id)
        |> Repo.preload(:associated_model)

      assert ProjectModels.find_project_model_association!(
               project_slug,
               model.slug,
               association.name
             ) ==
               association
    end

    test "find_project_model_association/3 raises Ecto.NotFound error" do
      assert_raise Ecto.NoResultsError, fn ->
        ProjectModels.find_project_model_association!("", "", "")
      end
    end
  end

  describe "list Project's Model's associations" do
    test "list_project_model_associations/2 returns all model's associations" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      %Model{id: model_id, slug: model_slug} = model_fixture(project_id: project_id)
      associated_model = model_fixture(project_id: project_id, name: "Aurhor", slug: "author")

      association =
        model_association_fixture(model_id: model_id, associated_model_id: associated_model.id)
        |> Repo.preload(:associated_model)

      model_association_fixture()

      assert ProjectModels.list_project_model_associations(project_slug, model_slug) == [
               association
             ]
    end
  end
end
