defmodule Gymnasium.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gymnasium.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        archived_at: nil,
        description: "An online platform for buying and selling books.",
        name: "Bookstore",
        slug: "bookstore"
      })
      |> Gymnasium.Dimensions.create_project()

    project
  end

  @doc """
  Generate an archived project.
  """
  def archived_project_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      description: "Recipes sharing web app.",
      name: "Food service",
      slug: "food-service"
    })
    |> Map.put(:archived_at, DateTime.utc_now())
    |> project_fixture()
  end
end
