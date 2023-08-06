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
        slug: "bookstore"
      })
      |> Gymnasium.Dimensions.create_project()

    project
  end
end
