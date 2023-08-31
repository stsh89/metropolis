defmodule GymnasiumGrpc.ModelServiceTest do
  use Gymnasium.DataCase

  alias GymnasiumGrpc.ModelService
  alias Gymnasium.Projects.Project
  alias Gymnasium.Models.{Model, Association, Attribute}
  alias Gymnasium.AttributeTypes.AttributeType
  alias Gymnasium.Projects
  alias Gymnasium.Models

  alias GymnasiumGrpc.ModelService.{
    CreateModelAttributes,
    FindProjectModelAttributes,
    FindProjectModelAssociationAttributes,
    FindProjectModelAttributeAttributes,
    CreateAssociationAttributes,
    CreateAttributeAttributes,
    FindProjectModelOverviewAttributes
  }

  import Gymnasium.{ProjectsFixtures, ModelsFixtures, AttributeTypesFixtures}

  describe "create a new Model" do
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

  describe "find project model overview" do
    test "find_project_model_overview!/1 returns found Model" do
      %Project{id: project_id, slug: project_slug} = project_fixture()

      model =
        model_fixture(project_id: project_id)
        |> Repo.preload([:attributes, :associations])

      attributes = %FindProjectModelOverviewAttributes{
        project_slug: project_slug,
        model_slug: model.slug
      }

      assert ModelService.find_project_model_overview!(attributes) == model
    end

    test "find_project_model_overview!/1 raises Ecto.NotFound error" do
      assert_raise Ecto.NoResultsError, fn ->
        ModelService.find_project_model_overview!(%FindProjectModelOverviewAttributes{
          project_slug: "book-store",
          model_slug: "book"
        })
      end
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

  describe "find Project's Model association" do
    test "find_project_model_association/1 returns found Model association" do
      project = project_fixture()
      model = model_fixture(project_id: project.id)
      associated_model = model_fixture(project_id: project.id, name: "Author", slug: "author")

      association =
        model_association_fixture(model_id: model.id, associated_model_id: associated_model.id)
        |> Repo.preload(:associated_model)

      attributes = %FindProjectModelAssociationAttributes{
        project_slug: project.slug,
        model_slug: model.slug,
        association_name: association.name
      }

      assert ModelService.find_project_model_association(attributes) == association
    end

    test "find_project_model_association/1 returns nil when Model is not found" do
      assert ModelService.find_project_model_association(%FindProjectModelAssociationAttributes{}) ==
               nil
    end
  end

  describe "find Project's Model attribute" do
    test "find_project_model_attribute/1 returns found Model" do
      project = project_fixture()
      model = model_fixture(project_id: project.id)
      attribute = model_attribute_fixture(model_id: model.id) |> Repo.preload(:attribute_type)

      attributes = %FindProjectModelAttributeAttributes{
        project_slug: project.slug,
        model_slug: model.slug,
        attribute_name: attribute.name
      }

      assert ModelService.find_project_model_attribute(attributes) == attribute
    end

    test "find_project_model_attribute/1 returns nil when Model is not found" do
      assert ModelService.find_project_model_attribute(%FindProjectModelAttributeAttributes{}) ==
               nil
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

  describe "create a new Model association" do
    test "create_association/1 saves model association" do
      %Model{id: model_id} = model_fixture()
      %Model{id: associated_model_id} = model_fixture(name: "Author", slug: "author")

      attributes = %CreateAssociationAttributes{
        model_id: model_id,
        associated_model_id: associated_model_id,
        kind: "belongs_to",
        name: "Author"
      }

      assert %Association{} = ModelService.create_association(attributes)
      assert false == Models.list_associations() |> Enum.empty?()
    end

    test "create_association/1 does not save model association with malformed arguments" do
      attributes = %CreateAssociationAttributes{}

      assert :error = ModelService.create_association(attributes)
      assert true == Models.list_associations() |> Enum.empty?()
    end
  end

  describe "delete Model association" do
    test "delete_association/1 returns :ok on successfull deletion" do
      %Association{id: id} = model_association_fixture()

      assert ModelService.delete_association(id) == :ok
      assert true == Models.list_associations() |> Enum.empty?()
    end

    test "delete_model/1 returns :error on failed deletion" do
      assert ModelService.delete_association(Ecto.UUID.generate()) == :error
    end
  end

  describe "create a new Model attribute" do
    test "create_attribute/1 saves model attribute" do
      %Model{id: model_id} = model_fixture()
      %AttributeType{id: attribute_type_id} = attribute_type_fixture()

      attributes = %CreateAttributeAttributes{
        attribute_type_id: attribute_type_id,
        model_id: model_id,
        kind: "string",
        name: "title"
      }

      assert %Attribute{} = ModelService.create_attribute(attributes)
      assert false == Models.list_attributes() |> Enum.empty?()
    end

    test "create_attribute/1 does not save model attribute with malformed arguments" do
      attributes = %CreateAttributeAttributes{}

      assert :error = ModelService.create_attribute(attributes)
      assert true == Models.list_attributes() |> Enum.empty?()
    end
  end

  describe "delete Model attribute" do
    test "delete_attribute/1 returns :ok on successfull deletion" do
      %Attribute{id: id} = model_attribute_fixture()

      assert ModelService.delete_attribute(id) == :ok
      assert true == Models.list_attributes() |> Enum.empty?()
    end

    test "delete_model/1 returns :error on failed deletion" do
      assert ModelService.delete_attribute(Ecto.UUID.generate()) == :error
    end
  end
end
