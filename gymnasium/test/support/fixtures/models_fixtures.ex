defmodule Gymnasium.ModelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gymnasium.Models` context.
  """

  @doc """
  Generate a model.
  """
  def model_fixture(attrs \\ %{}) do
    {:ok, model} =
      attrs
      |> Enum.into(%{
        project_id: Ecto.UUID.generate(),
        description: "Books model",
        name: "Book",
        slug: "book"
      })
      |> Gymnasium.Dimensions.create_model()

    model
  end

  @doc """
  Generate a model attribute.
  """
  def model_attribute_fixture(attrs \\ %{}) do
    {:ok, model_attribute} =
      attrs
      |> Enum.into(%{
        model_id: Ecto.UUID.generate(),
        description: "The title of the Book",
        kind: "string",
        name: "title"
      })
      |> Gymnasium.Dimensions.create_model_attribute()

    model_attribute
  end

  @doc """
  Generate a model association.
  """
  def model_association_fixture(attrs \\ %{}) do
    {:ok, model_association} =
      attrs
      |> Enum.into(%{
        model_id: nil,
        associated_model_id: nil,
        description: "The Author of the BOok",
        kind: "belongs_to",
        name: "author"
      })
      |> Gymnasium.Models.create_model_association()

    model_association
  end
end
