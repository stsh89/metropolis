defmodule GymnasiumGrpc.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger
  intercept GymnasiumGrpc.ExceptionInterceptor

  run([
    GymnasiumGrpc.AttributeTypesServer,
    GymnasiumGrpc.HealthServer,
    GymnasiumGrpc.ModelsServer,
    GymnasiumGrpc.ProjectsServer
  ])
end
