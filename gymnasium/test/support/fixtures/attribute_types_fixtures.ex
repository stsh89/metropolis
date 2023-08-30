defmodule Gymnasium.AttributeTypesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gymnasium.AttributeTypes` context.
  """

  @doc """
  Generate a attribute_type.
  """
  def attribute_type_fixture(attrs \\ %{}) do
    {:ok, attribute_type} =
      attrs
      |> Enum.into(%{
        name: "Bigint",
        description: "Large-range integer.",
        slug: "bigint"
      })
      |> Gymnasium.AttributeTypes.create_attribute_type()

    attribute_type
  end
end
