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
        name: "some name",
        description: "some description",
        create_timestamp: ~N[2023-07-31 13:33:00]
      })
      |> Gymnasium.Projects.create_project()

    project
  end
end
