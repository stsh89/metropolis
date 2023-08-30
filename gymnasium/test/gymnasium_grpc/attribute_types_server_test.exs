defmodule GymnasiumGrpc.AttributeTypesServerTest do
  use Gymnasium.DataCase

  alias GymnasiumGrpc.AttributeTypesServer
  alias Proto.Gymnasium.V1.AttributeTypes, as: Rpc

  import Gymnasium.AttributeTypesFixtures

  describe "create attribute type" do
    test "create_attribute_type/2 saves attribute type" do
      proto_attribute_type =
        AttributeTypesServer.create_attribute_type(
          %Rpc.CreateAttributeTypeRequest{
            name: "Bigint",
            slug: "bigint",
            description: "Large-range integer."
          },
          nil
        )

      assert %Rpc.AttributeType{name: name} = proto_attribute_type
      assert name == "Bigint"
    end

    test "create_attribute_type/2 returns error when request contains malformed" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        AttributeTypesServer.create_attribute_type(
          %Rpc.CreateAttributeTypeRequest{
            name: "",
            slug: ""
          },
          nil
        )
      end
    end
  end

  describe "list attribute types" do
    test "list_attribute_types/2 returns all attribute types" do
      attribute_type = attribute_type_fixture()

      %Rpc.ListAttributeTypesResponse{attribute_types: attribute_types} =
        AttributeTypesServer.list_attribute_types(
          %Rpc.ListAttributeTypesRequest{},
          nil
        )

      assert [attribute_type.id] == Enum.map(attribute_types, fn at -> at.id end)
    end
  end

  describe "find attribute type" do
    test "find_attribute_type/2 returns attribute type" do
      attribute_type = attribute_type_fixture()

      %Rpc.AttributeType{id: id} =
        AttributeTypesServer.find_attribute_type(
          %Rpc.FindAttributeTypeRequest{
            slug: attribute_type.slug
          },
          nil
        )

      assert id == attribute_type.id
    end

    test "find_attribute_type/2 raises NotFound error" do
      assert_raise Ecto.NoResultsError fn ->
        AttributeTypesServer.find_attribute_type(
          %Rpc.FindAttributeTypeRequest{
            slug: ""
          },
          nil
        )
      end
    end
  end

  describe "update attribute type" do
    test "update_attribute_type/2 updates attribute type" do
      attribute_type = attribute_type_fixture()

      proto_attribute_type =
        AttributeTypesServer.update_attribute_type(
          %Rpc.UpdateAttributeTypeRequest{
            attribute_type: %Rpc.AttributeType{
              id: attribute_type.id,
              name: "Float",
              slug: "float",
              description: "Inexact, variable-precision numeric type."
            },
            update_mask: %Google.Protobuf.FieldMask{
              paths: ["name", "slug", "description"]
            }
          },
          nil
        )

      assert proto_attribute_type.name == "Float"
      assert proto_attribute_type.slug == "float"
      assert proto_attribute_type.description == "Inexact, variable-precision numeric type."
    end

    test "update_attribute_type/2 raises internal error" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        AttributeTypesServer.update_attribute_type(
          %Rpc.UpdateAttributeTypeRequest{
            attribute_type: %Rpc.AttributeType{
              id: Ecto.UUID.generate(),
              name: "Float"
            },
            update_mask: %Google.Protobuf.FieldMask{
              paths: ["name"]
            }
          },
          nil
        )
      end
    end
  end

  describe "delete attribute type" do
    test "delete_attribute_type/2 removes attribute type" do
      attribute_type = attribute_type_fixture()

      response =
        AttributeTypesServer.delete_attribute_type(
          %Rpc.DeleteAttributeTypeRequest{
            id: attribute_type.id
          },
          nil
        )

      assert %Google.Protobuf.Empty{} == response
    end

    test "delete_attribute_type/2 raises internal error" do
      assert_raise GRPC.RPCError, "Internal errors", fn ->
        AttributeTypesServer.delete_attribute_type(
          %Rpc.DeleteAttributeTypeRequest{
            id: Ecto.UUID.generate()
          },
          nil
        )
      end
    end
  end
end
