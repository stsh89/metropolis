defmodule Proto.Gymnasium.V1.Dimensions.ModelScalarAttributeKind do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :MODEL_SCALAR_ATTRIBUTE_KIND_UNSPECIFIED, 0
  field :MODEL_SCALAR_ATTRIBUTE_KIND_STRING, 1
  field :MODEL_SCALAR_ATTRIBUTE_KIND_INT64, 2
  field :MODEL_SCALAR_ATTRIBUTE_KIND_BOOL, 3
end

defmodule Proto.Gymnasium.V1.Dimensions.Model do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_id, 1, type: :string, json_name: "projectId"
  field :id, 2, type: :string
  field :name, 3, type: :string
  field :description, 4, type: :string
  field :create_time, 5, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :slug, 6, type: :string
  field :attributes, 7, repeated: true, type: Proto.Gymnasium.V1.Dimensions.ModelAttribute
end

defmodule Proto.Gymnasium.V1.Dimensions.ModelAttribute do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  oneof :kind, 0

  field :model_id, 1, type: :string, json_name: "modelId"
  field :name, 2, type: :string
  field :description, 3, type: :string

  field :scalar, 4,
    type: Proto.Gymnasium.V1.Dimensions.ModelScalarAttributeKind,
    enum: true,
    oneof: 0

  field :reference, 5, type: :string, oneof: 0
  field :list, 6, type: :bool
end