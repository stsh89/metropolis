defmodule Proto.Gymnasium.V1.HealthCheck.HealthCheckStatus do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :HEALTH_CHECK_STATUS_UNSPECIFIED, 0
  field :HEALTH_CHECK_STATUS_HEALTHY, 1
  field :HEALTH_CHECK_STATUS_UNHEALTHY, 2
end

defmodule Proto.Gymnasium.V1.HealthCheck.GetHealthCheckRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"
end

defmodule Proto.Gymnasium.V1.HealthCheck.GetHealthCheckResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :status, 1, type: Proto.Gymnasium.V1.HealthCheck.HealthCheckStatus, enum: true
end

defmodule Proto.Gymnasium.V1.HealthCheck.HealthCheck.Service do
  @moduledoc false

  use GRPC.Service,
    name: "proto.gymnasium.v1.health_check.HealthCheck",
    protoc_gen_elixir_version: "0.12.0"

  rpc :GetHealthCheck,
      Proto.Gymnasium.V1.HealthCheck.GetHealthCheckRequest,
      Proto.Gymnasium.V1.HealthCheck.GetHealthCheckResponse
end

defmodule Proto.Gymnasium.V1.HealthCheck.HealthCheck.Stub do
  @moduledoc false

  use GRPC.Stub, service: Proto.Gymnasium.V1.HealthCheck.HealthCheck.Service
end