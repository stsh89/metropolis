defmodule GymnasiumGrpc.ParamsInterceptor do
  @moduledoc false

  require Logger

  @behaviour GRPC.Server.Interceptor

  @impl true
  def init(_opts \\ []) do
    []
  end

  @impl true
  def call(req, stream, next, _opts) do
    Logger.info(req)
    next.(req, stream)
  end
end
