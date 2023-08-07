defmodule Gymnasium.Config do
  @config Jason.decode!(
            Application.compile_env(:gymnasium, :external_config),
            keys: :atoms
          )[:gymnasium]

  def grpc_server_port do
    @config.server.port
    |> String.to_integer()
  end
end
