defmodule Proto.Gymnasium.V1.AttributeTypes.AttributeType do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
  field :description, 2, type: :string
  field :name, 3, type: :string
  field :slug, 4, type: :string
  field :create_time, 5, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :update_time, 6, type: Google.Protobuf.Timestamp, json_name: "updateTime"
end

defmodule Proto.Gymnasium.V1.AttributeTypes.CreateAttributeTypeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :description, 1, type: :string
  field :name, 2, type: :string
  field :slug, 3, type: :string
end

defmodule Proto.Gymnasium.V1.AttributeTypes.FindAttributeTypeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :slug, 1, type: :string
end

defmodule Proto.Gymnasium.V1.AttributeTypes.ListAttributeTypesRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"
end

defmodule Proto.Gymnasium.V1.AttributeTypes.ListAttributeTypesResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :attribute_types, 1,
    repeated: true,
    type: Proto.Gymnasium.V1.AttributeTypes.AttributeType,
    json_name: "attributeTypes"
end

defmodule Proto.Gymnasium.V1.AttributeTypes.UpdateAttributeTypeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :attribute_type, 1,
    type: Proto.Gymnasium.V1.AttributeTypes.AttributeType,
    json_name: "attributeType"

  field :update_mask, 2, type: Google.Protobuf.FieldMask, json_name: "updateMask"
end

defmodule Proto.Gymnasium.V1.AttributeTypes.DeleteAttributeTypeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
end

defmodule Proto.Gymnasium.V1.AttributeTypes.AttributeTypes.Service do
  @moduledoc false

  use GRPC.Service,
    name: "proto.gymnasium.v1.attribute_types.AttributeTypes",
    protoc_gen_elixir_version: "0.12.0"

  rpc :CreateAttributeType,
      Proto.Gymnasium.V1.AttributeTypes.CreateAttributeTypeRequest,
      Proto.Gymnasium.V1.AttributeTypes.AttributeType

  rpc :FindAttributeType,
      Proto.Gymnasium.V1.AttributeTypes.FindAttributeTypeRequest,
      Proto.Gymnasium.V1.AttributeTypes.AttributeType

  rpc :ListAttributeTypes,
      Proto.Gymnasium.V1.AttributeTypes.ListAttributeTypesRequest,
      Proto.Gymnasium.V1.AttributeTypes.ListAttributeTypesResponse

  rpc :UpdateAttributeType,
      Proto.Gymnasium.V1.AttributeTypes.UpdateAttributeTypeRequest,
      Proto.Gymnasium.V1.AttributeTypes.AttributeType

  rpc :DeleteAttributeType,
      Proto.Gymnasium.V1.AttributeTypes.DeleteAttributeTypeRequest,
      Google.Protobuf.Empty
end

defmodule Proto.Gymnasium.V1.AttributeTypes.AttributeTypes.Stub do
  @moduledoc false

  use GRPC.Stub, service: Proto.Gymnasium.V1.AttributeTypes.AttributeTypes.Service
end