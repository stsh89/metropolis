defmodule Gymnasium.AttributeTypesTest do
  use Gymnasium.DataCase

  alias Gymnasium.AttributeTypes
  alias Gymnasium.AttributeTypes.AttributeType

  import Gymnasium.AttributeTypesFixtures

  describe "create attribute type" do
    test "create_attribute_type/1 saves attribute type" do
      attrs = %{
        description: "Large-range integer.",
        name: "Bigint",
        slug: "bigint"
      }

      assert {:ok, %AttributeType{} = attribute_type} =
               AttributeTypes.create_attribute_type(attrs)

      assert attribute_type.description == "Large-range integer."
      assert attribute_type.name == "Bigint"
      assert attribute_type.slug == "bigint"
    end

    test "create_attribute_type/1 validates name presence" do
      attrs = %{
        description: "Large-range integer.",
        name: "",
        slug: "bigint"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} =
               AttributeTypes.create_attribute_type(attrs)

      assert errors == [name: {"can't be blank", [validation: :required]}]
    end

    test "create_attribute_type/1 validates slug presence" do
      attrs = %{
        description: "Large-range integer.",
        name: "Bigint",
        slug: ""
      }

      assert {:error, %Ecto.Changeset{errors: errors}} =
               AttributeTypes.create_attribute_type(attrs)

      assert errors == [slug: {"can't be blank", [validation: :required]}]
    end

    test "create_attribute_type/1 validates name duplicate" do
      %AttributeType{name: name} = attribute_type_fixture()

      attrs = %{
        description: "Large-range integer.",
        name: name,
        slug: "some-slug"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} =
               AttributeTypes.create_attribute_type(attrs)

      assert errors == [
               name:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "attribute_types_name_index"]}
             ]
    end

    test "create_attribute_type/1 validates slug duplicate" do
      %AttributeType{slug: slug} = attribute_type_fixture()

      attrs = %{
        description: "Large-range integer.",
        name: "Some name",
        slug: slug
      }

      assert {:error, %Ecto.Changeset{errors: errors}} =
               AttributeTypes.create_attribute_type(attrs)

      assert errors == [
               slug:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "attribute_types_slug_index"]}
             ]
    end
  end

  describe "find attribute type" do
    test "find_attribute_type/1 returns attribute type" do
      attribute_type = %AttributeType{slug: slug} = attribute_type_fixture()

      assert AttributeTypes.find_attribute_type!(slug) == attribute_type
    end

    test "find_attribute_type/1 raises error on missing attribute type" do
      assert_raise Ecto.NoResultsError, fn -> AttributeTypes.find_attribute_type!("") end
    end
  end

  describe "get attribute type" do
    test "get_attribute_type/1 returns attribute type" do
      attribute_type = %AttributeType{id: id} = attribute_type_fixture()

      assert AttributeTypes.get_attribute_type!(id) == attribute_type
    end

    test "get_attribute_type/1 raises error on missing attribute type" do
      assert_raise Ecto.NoResultsError, fn ->
        AttributeTypes.find_attribute_type!(Ecto.UUID.generate())
      end
    end
  end

  describe "list attribute types" do
    test "list_attribute_types/0 returns all attribute types" do
      attribute_type = attribute_type_fixture()

      assert AttributeTypes.list_attribute_types() == [attribute_type]
    end
  end

  describe "update attribute type" do
    test "update_attribute_type/2 updates attribute type" do
      attribute_type = attribute_type_fixture()

      attrs = %{
        description: "User-specified precision, exact.",
        name: "Decimal",
        slug: "decimal"
      }

      assert {:ok, %AttributeType{} = attribute_type} =
               AttributeTypes.update_attribute_type(attribute_type, attrs)

      assert attribute_type.description == "User-specified precision, exact."
      assert attribute_type.name == "Decimal"
      assert attribute_type.slug == "decimal"
    end

    test "update_attribute_type/2 validates name presence" do
      attribute_type = attribute_type_fixture()

      attrs = %{
        description: "User-specified precision, exact.",
        name: "",
        slug: "decimal"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} =
               AttributeTypes.update_attribute_type(attribute_type, attrs)

      assert errors == [name: {"can't be blank", [validation: :required]}]
    end

    test "update_attribute_type/2 validates slug presence" do
      attribute_type = attribute_type_fixture()

      attrs = %{
        description: "User-specified precision, exact.",
        name: "Decimal",
        slug: ""
      }

      assert {:error, %Ecto.Changeset{errors: errors}} =
               AttributeTypes.update_attribute_type(attribute_type, attrs)

      assert errors == [slug: {"can't be blank", [validation: :required]}]
    end

    test "update_attribute_type/2 validates name duplicate" do
      %AttributeType{name: name} =
        attribute_type_fixture(name: "Decimal", slug: "decimal", description: "")

      attribute_type = attribute_type_fixture()

      attrs = %{
        description: "User-specified precision, exact.",
        name: name,
        slug: "some-slug"
      }

      assert {:error, %Ecto.Changeset{errors: errors}} =
               AttributeTypes.update_attribute_type(attribute_type, attrs)

      assert errors == [
               name:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "attribute_types_name_index"]}
             ]
    end

    test "update_attribute_type/2 validates slug duplicate" do
      %AttributeType{slug: slug} =
        attribute_type_fixture(name: "Decimal", slug: "decimal", description: "")

      attribute_type = attribute_type_fixture()

      attrs = %{
        description: "User-specified precision, exact.",
        name: "Some name",
        slug: slug
      }

      assert {:error, %Ecto.Changeset{errors: errors}} =
               AttributeTypes.update_attribute_type(attribute_type, attrs)

      assert errors == [
               slug:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "attribute_types_slug_index"]}
             ]
    end
  end

  describe "delete attribute type" do
    test "delete_attribute_type/1 removes attribute type" do
      attribute_type = attribute_type_fixture()
      assert {:ok, %AttributeType{}} = AttributeTypes.delete_attribute_type(attribute_type)

      assert_raise Ecto.NoResultsError, fn ->
        AttributeTypes.get_attribute_type!(attribute_type.id)
      end
    end
  end
end
