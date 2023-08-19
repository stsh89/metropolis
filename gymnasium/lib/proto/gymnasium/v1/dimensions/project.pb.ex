defmodule Proto.Gymnasium.V1.Dimensions.Project do
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
