defmodule GymnasiumGrpc.ExceptionInterceptor do
  @moduledoc false

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
        reraise GRPC.RPCError, [status: :not_found, exception: e], __STACKTRACE__

      e ->
        reraise GRPC.RPCError, [status: :internal, exception: e], __STACKTRACE__
    end
  end
end
