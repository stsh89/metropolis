defmodule Proto.Gymnasium.V1.Dimensions.ModelAssociationKind do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :UnspecifiedAssociationKind, 0
  field :BelongsTo, 1
  field :HasOne, 2
  field :HasMany, 3
end

defmodule Proto.Gymnasium.V1.Dimensions.ModelAttributeKind do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :UnspecifiedAttributeKind, 0
  field :String, 1
  field :Int64, 2
  field :Bool, 3
end

defmodule Proto.Gymnasium.V1.Dimensions.Model do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
  field :project_id, 2, type: :string, json_name: "projectId"
  field :description, 3, type: :string
  field :name, 4, type: :string
  field :slug, 5, type: :string
  field :create_time, 6, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :update_time, 7, type: Google.Protobuf.Timestamp, json_name: "updateTime"
end

defmodule Proto.Gymnasium.V1.Dimensions.ModelAssociation do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
  field :model_id, 2, type: :string, json_name: "modelId"

  field :associated_model, 3,
    type: Proto.Gymnasium.V1.Dimensions.Model,
    json_name: "associatedModel"

  field :description, 4, type: :string
  field :kind, 5, type: Proto.Gymnasium.V1.Dimensions.ModelAssociationKind, enum: true
  field :name, 6, type: :string
  field :create_time, 7, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :update_time, 8, type: Google.Protobuf.Timestamp, json_name: "updateTime"
end

defmodule Proto.Gymnasium.V1.Dimensions.ModelAttribute do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
  field :model_id, 2, type: :string, json_name: "modelId"
  field :description, 3, type: :string
  field :kind, 4, type: Proto.Gymnasium.V1.Dimensions.ModelAttributeKind, enum: true
  field :name, 5, type: :string
  field :create_time, 6, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :update_time, 7, type: Google.Protobuf.Timestamp, json_name: "updateTime"
end