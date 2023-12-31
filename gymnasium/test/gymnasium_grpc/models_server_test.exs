defmodule GymnasiumGrpc.ModelsServerTest do
  use Gymnasium.DataCase

  alias GymnasiumGrpc.ModelsServer
  alias Gymnasium.Models.{Model, Association, Attribute}
  alias Gymnasium.Projects.Project

  alias Proto.Gymnasium.V1.Models, as: Rpc

  alias Proto.Gymnasium.V1.Models.{
    CreateModelRequest,
    DeleteModelRequest,
    ListProjectModelsResponse,
    ListProjectModelsRequest,
    FindProjectModelRequest,
    FindProjectModelAssociationRequest,
    FindProjectModelAttributeRequest,
    DeleteAssociationRequest,
    DeleteAttributeRequest,
    CreateAssociationRequest,
    CreateAttributeRequest,
    ListProjectModelAssociationsRequest,
    ListProjectModelAttributesRequest,
    ListProjectModelAssociationsResponse,
    ListProjectModelAttributesResponse
  }

  import Gymnasium.{ModelsFixtures, ProjectsFixtures, AttributeTypesFixtures}

  alias Proto.Gymnasium.V1.Models.Model, as: ProtoModel
  alias Proto.Gymnasium.V1.Models.Association, as: ProtoAssociation
  alias Proto.Gymnasium.V1.Models.Attribute, as: ProtoAttribute

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

  describe "find project model overview" do
    test "find_project_model_overview/2 returns model with attributes and associations for given project slug" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      associated_model = model_fixture(project_id: project_id, name: "Author", slug: "author")
      attribute_type = attribute_type_fixture()

      attribute =
        model_attribute_fixture(model_id: model.id, attribute_type_id: attribute_type.id)

      association =
        model_association_fixture(model_id: model.id, associated_model_id: associated_model.id)

      assert %Rpc.ModelOverview{} =
               model_overview =
               ModelsServer.find_project_model_overview(
                 %Rpc.FindProjectModelOverviewRequest{
                   project_slug: project_slug,
                   model_slug: model.slug
                 },
                 nil
               )

      assert %{
               model: model_overview.model.name,
               attributes: model_overview.attributes |> Enum.map(fn a -> a.name end),
               associations: model_overview.associations |> Enum.map(fn a -> a.name end)
             } ==
               %{
                 model: model.name,
                 attributes: [attribute.name],
                 associations: [association.name]
               }
    end

    test "find_project_model_overview/2 raises NotFound error" do
      assert_raise Ecto.NoResultsError,
                   fn ->
                     ModelsServer.find_project_model_overview(
                       %Rpc.FindProjectModelOverviewRequest{
                         project_slug: "book-store",
                         model_slug: "book"
                       },
                       nil
                     )
                   end
    end
  end

  describe "Project model overviews listing" do
    test "list_project_model_overviews/2 returns models with attributes and associations for given project slug" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      associated_model = model_fixture(project_id: project_id, name: "Author", slug: "author")
      attribute_type = attribute_type_fixture()

      attribute =
        model_attribute_fixture(model_id: model.id, attribute_type_id: attribute_type.id)
        |> Repo.preload(:attribute_type)

      association =
        model_association_fixture(model_id: model.id, associated_model_id: associated_model.id)

      %Rpc.ListProjectModelOverviewsResponse{model_overviews: model_overviews} =
        ModelsServer.list_project_model_overviews(
          %Rpc.ListProjectModelOverviewsRequest{
            project_slug: project_slug
          },
          nil
        )

      assert_result =
        Enum.map(model_overviews, fn mo ->
          %{
            model: mo.model.name,
            attributes: mo.attributes |> Enum.map(fn a -> a.name end),
            associations: mo.associations |> Enum.map(fn a -> a.name end)
          }
        end)

      assert assert_result == [
               %{
                 model: associated_model.name,
                 attributes: [],
                 associations: []
               },
               %{
                 model: model.name,
                 attributes: [attribute.name],
                 associations: [association.name]
               }
             ]
    end
  end

  describe "Project models associations listing" do
    test "list_project_model_associations/2 returns all models for given project slug" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      associated_model = model_fixture(project_id: project_id, name: "Author", slug: "author")

      association =
        model_association_fixture(model_id: model.id, associated_model_id: associated_model.id)

      %ListProjectModelAssociationsResponse{associations: list} =
        ModelsServer.list_project_model_associations(
          %ListProjectModelAssociationsRequest{
            project_slug: project_slug,
            model_slug: model.slug
          },
          nil
        )

      assert_associations(list, [association])
    end

    defp assert_associations(list, expected_list) do
      assert Enum.map(list, fn m -> m.name end) == Enum.map(expected_list, fn m -> m.name end)
    end
  end

  describe "Project models attributes listing" do
    test "list_project_model_attributes/2 returns all models for given project slug" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      attribute_type = attribute_type_fixture()

      attribute =
        model_attribute_fixture(model_id: model.id, attribute_type_id: attribute_type.id)
        |> Repo.preload(:attribute_type)

      %ListProjectModelAttributesResponse{attributes: list} =
        ModelsServer.list_project_model_attributes(
          %ListProjectModelAttributesRequest{
            project_slug: project_slug,
            model_slug: model.slug
          },
          nil
        )

      assert_attributes(list, [attribute])
    end

    defp assert_attributes(list, expected_list) do
      assert Enum.map(list, fn m -> m.name end) == Enum.map(expected_list, fn m -> m.name end)
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

  describe "find Project's Model association" do
    test "find_project_model_association/2 returns found association" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      associated_model = model_fixture(name: "Author", slug: "author", project_id: project_id)

      association =
        model_association_fixture(model_id: model.id, associated_model_id: associated_model.id)

      proto_association =
        ModelsServer.find_project_model_association(
          %FindProjectModelAssociationRequest{
            project_slug: project_slug,
            model_slug: model.slug,
            association_name: association.name
          },
          nil
        )

      assert association.name == proto_association.name
    end

    test "find_project_model_association/2 raises NotFound error" do
      assert_raise GRPC.RPCError,
                   "Association \"\" not found for Project \"\" and Model \"\".",
                   fn ->
                     ModelsServer.find_project_model_association(
                       %FindProjectModelAssociationRequest{
                         project_slug: "",
                         model_slug: "",
                         association_name: ""
                       },
                       nil
                     )
                   end
    end
  end

  describe "find Project's Model attribute" do
    test "find_project_model_attribute/2 returns found Model" do
      %Project{id: project_id, slug: project_slug} = project_fixture()
      model = model_fixture(project_id: project_id)
      attribute_type = attribute_type_fixture()

      attribute =
        model_attribute_fixture(model_id: model.id, attribute_type_id: attribute_type.id)

      proto_attribute =
        ModelsServer.find_project_model_attribute(
          %FindProjectModelAttributeRequest{
            project_slug: project_slug,
            model_slug: model.slug,
            attribute_name: attribute.name
          },
          nil
        )

      assert attribute.name == proto_attribute.name
    end

    test "find_project_model_attribute/2 raises NotFound error" do
      assert_raise GRPC.RPCError,
                   "Attribute \"\" not found for Project \"\" and Model \"\".",
                   fn ->
                     ModelsServer.find_project_model_attribute(
                       %FindProjectModelAttributeRequest{
                         project_slug: "",
                         model_slug: "",
                         attribute_name: ""
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

  describe "create the Model association" do
    test "create_association/2 saves Model association" do
      model = model_fixture()
      associated_model = model_fixture(name: "Author", slug: "author")

      proto_association =
        ModelsServer.create_association(
          %CreateAssociationRequest{
            model_id: model.id,
            associated_model_id: associated_model.id,
            name: "Author",
            kind: :ASSOCIATION_KIND_BELONGS_TO,
            description: ""
          },
          nil
        )

      assert %ProtoAssociation{name: name} = proto_association
      assert name == "Author"
    end

    test "create_association/2 returns error when request values are malformed" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        ModelsServer.create_association(
          %CreateAssociationRequest{},
          nil
        )
      end
    end
  end

  describe "delete Model association by id" do
    test "delete_association/2 returns Google.Protobuf.Empty response" do
      %Association{id: id} = model_association_fixture()

      response =
        ModelsServer.delete_association(
          %DeleteAssociationRequest{
            id: id
          },
          nil
        )

      assert %Google.Protobuf.Empty{} == response
    end

    test "delete_association/2 raises internal error" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        ModelsServer.delete_association(
          %DeleteAssociationRequest{
            id: Ecto.UUID.generate()
          },
          nil
        )
      end
    end
  end

  describe "create the Model attribute" do
    test "create_attribute/2 saves Model attribute" do
      model = model_fixture()
      attribute_type = attribute_type_fixture()

      proto_attribute =
        ModelsServer.create_attribute(
          %CreateAttributeRequest{
            model_id: model.id,
            name: "Title",
            attribute_type_id: attribute_type.id,
            description: ""
          },
          nil
        )

      assert %ProtoAttribute{name: name} = proto_attribute
      assert name == "Title"
    end

    test "create_attribute/2 returns error when request values are malformed" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        ModelsServer.create_attribute(
          %CreateAttributeRequest{},
          nil
        )
      end
    end
  end

  describe "delete Model attribute by id" do
    test "delete_attribute/2 returns Google.Protobuf.Empty response" do
      %Attribute{id: id} = model_attribute_fixture()

      response =
        ModelsServer.delete_attribute(
          %DeleteAttributeRequest{
            id: id
          },
          nil
        )

      assert %Google.Protobuf.Empty{} == response
    end

    test "delete_attribute/2 raises internal error" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        ModelsServer.delete_attribute(
          %DeleteAttributeRequest{
            id: Ecto.UUID.generate()
          },
          nil
        )
      end
    end
  end
end
