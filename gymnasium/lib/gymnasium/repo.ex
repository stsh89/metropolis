defmodule Gymnasium.Repo do
  use Ecto.Repo,
    otp_app: :gymnasium,
    adapter: Ecto.Adapters.Postgres
end
