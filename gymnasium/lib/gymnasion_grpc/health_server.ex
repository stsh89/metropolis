defmodule GymnasiumGrpc.HealthServer do
  @moduledoc false

  use GRPC.Server, service: Proto.Gymnasium.V1.Health.Health.Service

  alias Proto.Gymnasium.V1.Health, as: Rpc

  def get_health_check(%Rpc.GetHealthCheckRequest{} = _request, _stream) do
    try do
      Gymnasium.HealthCheck.query_database()

      %Rpc.HealthCheck{state: :STATE_HEALTHY}
    rescue
      DBConnection.ConnectionError ->
        %Rpc.HealthCheck{state: :STATE_UNHEALTHY}

      _ ->
        %Rpc.HealthCheck{state: :STATE_UNSPECIFIED}
    end
  end
end
