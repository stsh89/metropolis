defmodule Proto.Gymnasium.V1.SelectDimensionRecordsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :parameters, 0

  field :project_parameters, 1,
    type: Proto.Gymnasium.V1.ProjectParameters,
    json_name: "projectParameters",
    oneof: 0
end

defmodule Proto.Gymnasium.V1.SelectDimensionRecordsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :records, 0

  field :project_records, 1,
    type: Proto.Gymnasium.V1.ProjectRecords,
    json_name: "projectRecords",
    oneof: 0
end

defmodule Proto.Gymnasium.V1.ProjectParameters do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"
end

defmodule Proto.Gymnasium.V1.ProjectRecords do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :records, 1, repeated: true, type: Proto.Gymnasium.V1.Dimensions.Project
end

defmodule Proto.Gymnasium.V1.Dimensions.Service do
  @moduledoc false

  use GRPC.Service, name: "proto.gymnasium.v1.Dimensions", protoc_gen_elixir_version: "0.12.0"

  rpc :SelectDimensionRecords,
      Proto.Gymnasium.V1.SelectDimensionRecordsRequest,
      Proto.Gymnasium.V1.SelectDimensionRecordsResponse
end

defmodule Proto.Gymnasium.V1.Dimensions.Stub do
  @moduledoc false

  use GRPC.Stub, service: Proto.Gymnasium.V1.Dimensions.Service
end