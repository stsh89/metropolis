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
        name: "some name",
        description: "some description"
      })
      |> Gymnasium.Dimensions.create_project()

    project
  end
end
