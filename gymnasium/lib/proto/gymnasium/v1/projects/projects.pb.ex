defmodule Proto.Gymnasium.V1.Projects.ProjectArchiveState do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :PROJECT_ARCHIVE_STATE_UNSPECIFIED, 0
  field :PROJECT_ARCHIVE_STATE_ARCHIVED, 1
  field :PROJECT_ARCHIVE_STATE_NOT_ARCHIVED, 2
  field :PROJECT_ARCHIVE_STATE_ANY, 3
end

defmodule Proto.Gymnasium.V1.Projects.Project do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
  field :description, 2, type: :string
  field :name, 3, type: :string
  field :slug, 4, type: :string
  field :archive_time, 5, type: Google.Protobuf.Timestamp, json_name: "archiveTime"
  field :create_time, 6, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :update_time, 7, type: Google.Protobuf.Timestamp, json_name: "updateTime"
end

defmodule Proto.Gymnasium.V1.Projects.ListProjectsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :archive_state, 1,
    type: Proto.Gymnasium.V1.Projects.ProjectArchiveState,
    json_name: "archiveState",
    enum: true
end

defmodule Proto.Gymnasium.V1.Projects.ListProjectsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :projects, 1, repeated: true, type: Proto.Gymnasium.V1.Projects.Project
end

defmodule Proto.Gymnasium.V1.Projects.FindProjectRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :slug, 1, type: :string
end

defmodule Proto.Gymnasium.V1.Projects.Projects.Service do
  @moduledoc false

  use GRPC.Service,
    name: "proto.gymnasium.v1.projects.Projects",
    protoc_gen_elixir_version: "0.12.0"

  rpc(
    :ListProjects,
    Proto.Gymnasium.V1.Projects.ListProjectsRequest,
    Proto.Gymnasium.V1.Projects.ListProjectsResponse
  )

  rpc(
    :FindProject,
    Proto.Gymnasium.V1.Projects.FindProjectRequest,
    Proto.Gymnasium.V1.Projects.Project
  )
end

defmodule Proto.Gymnasium.V1.Projects.Projects.Stub do
  @moduledoc false

  use GRPC.Stub, service: Proto.Gymnasium.V1.Projects.Projects.Service
end
