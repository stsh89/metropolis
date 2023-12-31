defmodule Gymnasium.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GymnasiumWeb.Telemetry,
      # Start the Ecto repository
      Gymnasium.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Gymnasium.PubSub},
      # Start Finch
      {Finch, name: Gymnasium.Finch},
      # Start the Endpoint (http/https)
      GymnasiumWeb.Endpoint,
      # Start a worker by calling: Gymnasium.Worker.start_link(arg)
      # {Gymnasium.Worker, arg}
      {GRPC.Server.Supervisor,
       endpoint: GymnasiumGrpc.Endpoint,
       port: Gymnasium.Config.grpc_server_port(),
       start_server: true}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gymnasium.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GymnasiumWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
