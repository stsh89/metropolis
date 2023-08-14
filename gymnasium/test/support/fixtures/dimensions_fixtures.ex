defmodule Gymnasium.DimensionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gymnasium.Dimensions` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "An online platform for buying and selling books.",
        name: "Bookstore",
        slug: "bookstore",
        archived_at: nil
      })
      |> Gymnasium.Dimensions.create_project()

    project
  end

  @doc """
  Generate a model.
  """
  def model_fixture(attrs \\ %{}) do
    {:ok, model} =
      attrs
      |> Enum.into(%{
        description: "Book model",
        name: "Book",
        slug: "book",
        project_id: attrs.project_id
      })
      |> Gymnasium.Dimensions.create_model()

    model
  end

  @doc """
  Generate a model.
  """
  def model_attribute_fixture(attrs \\ %{}) do
    {:ok, model_attribute} =
      attrs
      |> Enum.into(%{
        description: "The title of the Book",
        name: "title",
        model_id: attrs.model_id,
        kind: "scalar",
        kind_value: "string",
        list_indicator: "not_a_list"
      })
      |> Gymnasium.Dimensions.create_model_attribute()

    model_attribute
  end
end
