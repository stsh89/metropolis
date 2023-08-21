defmodule Gymnasium.Config do
  @moduledoc false

  @config :gymnasium
          |> Application.compile_env(:project_root_path)
          |> Path.join("config.json")
          |> File.read!()
          |> Jason.decode!(keys: :atoms)

  def grpc_server_port do
    @config
    |> Map.get(:grpc)
    |> Map.get(:server)
    |> Map.get(:port)
    |> String.to_integer()
  end
end
