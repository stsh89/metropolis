defmodule Proto.Gymnasium.V1.SelectDimensionRecordsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :record_parameters, 0

  field :project_record_parameters, 1,
    type: Proto.Gymnasium.V1.ProjectRecordParameters,
    json_name: "projectRecordParameters",
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

defmodule Proto.Gymnasium.V1.ProjectRecordParameters do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :archived, 1, type: :bool
end

defmodule Proto.Gymnasium.V1.ProjectRecords do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :records, 1, repeated: true, type: Proto.Gymnasium.V1.Dimensions.Project
end

defmodule Proto.Gymnasium.V1.StoreDimensionRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :record, 0

  field :project_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.Project,
    json_name: "projectRecord",
    oneof: 0
end

defmodule Proto.Gymnasium.V1.StoreDimensionRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :record, 0

  field :project_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.Project,
    json_name: "projectRecord",
    oneof: 0
end

defmodule Proto.Gymnasium.V1.FindDimensionRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :id, 0

  field :project_record_slug, 1, type: :string, json_name: "projectRecordSlug", oneof: 0
  field :project_record_id, 2, type: :string, json_name: "projectRecordId", oneof: 0
end

defmodule Proto.Gymnasium.V1.FindDimensionRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :record, 0

  field :project_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.Project,
    json_name: "projectRecord",
    oneof: 0
end

defmodule Proto.Gymnasium.V1.RemoveDimensionRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :id, 0

  field :project_record_id, 1, type: :string, json_name: "projectRecordId", oneof: 0
end

defmodule Proto.Gymnasium.V1.RemoveDimensionRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"
end

defmodule Proto.Gymnasium.V1.Dimensions.Service do
  @moduledoc false

  use GRPC.Service, name: "proto.gymnasium.v1.Dimensions", protoc_gen_elixir_version: "0.12.0"

  rpc :SelectDimensionRecords,
      Proto.Gymnasium.V1.SelectDimensionRecordsRequest,
      Proto.Gymnasium.V1.SelectDimensionRecordsResponse

  rpc :StoreDimensionRecord,
      Proto.Gymnasium.V1.StoreDimensionRecordRequest,
      Proto.Gymnasium.V1.StoreDimensionRecordResponse

  rpc :FindDimensionRecord,
      Proto.Gymnasium.V1.FindDimensionRecordRequest,
      Proto.Gymnasium.V1.FindDimensionRecordResponse

  rpc :RemoveDimensionRecord,
      Proto.Gymnasium.V1.RemoveDimensionRecordRequest,
      Proto.Gymnasium.V1.RemoveDimensionRecordResponse
end

defmodule Proto.Gymnasium.V1.Dimensions.Stub do
  @moduledoc false

  use GRPC.Stub, service: Proto.Gymnasium.V1.Dimensions.Service
end