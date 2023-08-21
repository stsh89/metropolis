defmodule Proto.Gymnasium.V1.Models.Model do
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

defmodule Proto.Gymnasium.V1.Models.CreateModelRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_id, 1, type: :string, json_name: "projectId"
  field :description, 2, type: :string
  field :name, 3, type: :string
  field :slug, 4, type: :string
end

defmodule Proto.Gymnasium.V1.Models.FindProjectModelRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
  field :model_slug, 2, type: :string, json_name: "modelSlug"
end

defmodule Proto.Gymnasium.V1.Models.ListProjectModelsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
end

defmodule Proto.Gymnasium.V1.Models.ListProjectModelsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :models, 1, repeated: true, type: Proto.Gymnasium.V1.Models.Model
end

defmodule Proto.Gymnasium.V1.Models.DeleteModelRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
end

defmodule Proto.Gymnasium.V1.Models.Models.Service do
  @moduledoc false

  use GRPC.Service, name: "proto.gymnasium.v1.models.Models", protoc_gen_elixir_version: "0.12.0"

  rpc(:CreateModel, Proto.Gymnasium.V1.Models.CreateModelRequest, Proto.Gymnasium.V1.Models.Model)

  rpc(
    :FindProjectModel,
    Proto.Gymnasium.V1.Models.FindProjectModelRequest,
    Proto.Gymnasium.V1.Models.Model
  )

  rpc(
    :ListProjectModels,
    Proto.Gymnasium.V1.Models.ListProjectModelsRequest,
    Proto.Gymnasium.V1.Models.ListProjectModelsResponse
  )

  rpc(:DeleteModel, Proto.Gymnasium.V1.Models.DeleteModelRequest, Google.Protobuf.Empty)
end

defmodule Proto.Gymnasium.V1.Models.Models.Stub do
  @moduledoc false

  use GRPC.Stub, service: Proto.Gymnasium.V1.Models.Models.Service
end
