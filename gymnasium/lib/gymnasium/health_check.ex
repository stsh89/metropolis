defmodule Gymnasium.HealthCheck do
  @moduledoc """
  The HealthCheck context.
  """

  import Ecto.Query, warn: false
  alias Gymnasium.Repo

  def query_database do
    query = from p in Gymnasium.Dimensions.Project, select: [:id], limit: 1

    Repo.all(query)
  end
end
