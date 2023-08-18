defmodule GymnasiumGrpc.HealthCheckServer do
  use GRPC.Server, service: Proto.Gymnasium.V1.HealthCheck.Service

  alias Proto.Gymnasium.V1.{
    GetHealthCheckRequest,
    GetHealthCheckResponse
  }

  @valid_health_check_statuses [
    :HealthCheckStatusHealthy,
    :HealthCheckStatusUnhealthy,
    :HealthCheckStatusUnspecified
  ]

  def get_health_check(%GetHealthCheckRequest{} = _request, _stream) do
    try do
      Gymnasium.HealthCheck.query_database()

      healthy()
    rescue
      DBConnection.ConnectionError -> unhealthy()
      _ -> unspecified()
    end
  end

  defp healthy() do
    get_health_check_response(:HealthCheckStatusHealthy)
  end

  defp unhealthy() do
    get_health_check_response(:HealthCheckStatusUnhealthy)
  end

  defp unspecified() do
    get_health_check_response(:HealthCheckStatusUnspecified)
  end

  defp get_health_check_response(status) when status in @valid_health_check_statuses do
    %GetHealthCheckResponse{status: status}
  end

  defp get_health_check_response(_) do
    get_health_check_response(:HealthCheckStatusUnspecified)
  end
end
