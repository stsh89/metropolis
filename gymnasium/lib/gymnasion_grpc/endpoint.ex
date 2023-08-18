defmodule GymnasiumGrpc.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger

  run([
    Proto.Gymnasium.V1.Dimensions.Server,
    GymnasiumGrpc.HealthCheckServer
  ])
end
