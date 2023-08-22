defmodule Proto.Gymnasium.V1.Health.HealthCheck.State do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :STATE_UNSPECIFIED, 0
  field :STATE_HEALTHY, 1
  field :STATE_UNHEALTHY, 2
end

defmodule Proto.Gymnasium.V1.Health.HealthCheck do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :state, 1, type: Proto.Gymnasium.V1.Health.HealthCheck.State, enum: true
end

defmodule Proto.Gymnasium.V1.Health.GetHealthCheckRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"
end

defmodule Proto.Gymnasium.V1.Health.Health.Service do
  @moduledoc false

  use GRPC.Service, name: "proto.gymnasium.v1.health.Health", protoc_gen_elixir_version: "0.12.0"

  rpc :GetHealthCheck,
      Proto.Gymnasium.V1.Health.GetHealthCheckRequest,
      Proto.Gymnasium.V1.Health.HealthCheck
end

defmodule Proto.Gymnasium.V1.Health.Health.Stub do
  @moduledoc false

  use GRPC.Stub, service: Proto.Gymnasium.V1.Health.Health.Service
end