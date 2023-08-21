defmodule Gymnasium.HealthCheck do
  @moduledoc """
  The HealthCheck context.
  """

  import Ecto.Query, warn: false
  alias Gymnasium.Repo

  alias Gymnasium.Projects.Project

  def query_database do
    query = from p in Project, select: [:id], limit: 1

    Repo.all(query)
  end
end
