defmodule GymnasiumGrpc.HealthCheckServer do
  @moduledoc false

  use GRPC.Server, service: Proto.Gymnasium.V1.HealthCheck.HealthCheck.Service

  alias Proto.Gymnasium.V1.HealthCheck, as: Proto

  def get_health_check(%Proto.GetHealthCheckRequest{} = _request, _stream) do
    try do
      Gymnasium.HealthCheck.query_database()

      %Proto.GetHealthCheckResponse{status: :HEALTH_CHECK_STATUS_HEALTHY}
    rescue
      DBConnection.ConnectionError ->
        %Proto.GetHealthCheckResponse{status: :HEALTH_CHECK_STATUS_UNHEALTHY}

      _ ->
        %Proto.GetHealthCheckResponse{status: :HEALTH_CHECK_STATUS_UNSPECIFIED}
    end
  end
end
