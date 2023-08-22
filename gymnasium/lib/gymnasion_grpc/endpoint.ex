defmodule GymnasiumGrpc.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger

  run([
    GymnasiumGrpc.HealthServer,
    GymnasiumGrpc.ModelsServer,
    GymnasiumGrpc.ProjectsServer
  ])
end
