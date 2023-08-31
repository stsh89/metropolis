defmodule GymnasiumGrpc.ExceptionInterceptor do
  @moduledoc false

  require Logger

  @behaviour GRPC.Server.Interceptor

  @impl true
  def init(_opts \\ []) do
    []
  end

  @impl true
  def call(req, stream, next, _opts) do
    try do
      next.(req, stream)
    rescue
      e in Ecto.NoResultsError ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))

        reraise GRPC.RPCError, [status: :not_found], __STACKTRACE__

      e ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))

        reraise GRPC.RPCError, [status: :internal], __STACKTRACE__
    end
  end
end
