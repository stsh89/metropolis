defmodule GymnasiumGrpc.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger

  run([
    GymnasiumGrpc.DimensionsServer,
    GymnasiumGrpc.HealthCheckServer,
    GymnasiumGrpc.ProjectsServer
  ])
end
