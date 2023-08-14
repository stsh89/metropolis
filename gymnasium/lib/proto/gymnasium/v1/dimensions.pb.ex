defmodule Proto.Gymnasium.V1.ListProjectRecordsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :archived, 1, type: :bool
end

defmodule Proto.Gymnasium.V1.ListProjectRecordsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_records, 1,
    repeated: true,
    type: Proto.Gymnasium.V1.Dimensions.Project,
    json_name: "projectRecords"
end

defmodule Proto.Gymnasium.V1.GetProjectRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :slug, 1, type: :string
end

defmodule Proto.Gymnasium.V1.GetProjectRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.Project,
    json_name: "projectRecord"
end

defmodule Proto.Gymnasium.V1.CreateProjectRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :description, 1, type: :string
  field :name, 2, type: :string
  field :slug, 3, type: :string
end

defmodule Proto.Gymnasium.V1.CreateProjectRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.Project,
    json_name: "projectRecord"
end

defmodule Proto.Gymnasium.V1.ArchiveProjectRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
end

defmodule Proto.Gymnasium.V1.ArchiveProjectRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.Project,
    json_name: "projectRecord"
end

defmodule Proto.Gymnasium.V1.RestoreProjectRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
end

defmodule Proto.Gymnasium.V1.RestoreProjectRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.Project,
    json_name: "projectRecord"
end

defmodule Proto.Gymnasium.V1.DeleteProjectRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
end

defmodule Proto.Gymnasium.V1.DeleteProjectRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"
end

defmodule Proto.Gymnasium.V1.RenameProjectRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
  field :name, 2, type: :string
  field :slug, 3, type: :string
end

defmodule Proto.Gymnasium.V1.RenameProjectRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.Project,
    json_name: "projectRecord"
end

defmodule Proto.Gymnasium.V1.ListModelRecordsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
end

defmodule Proto.Gymnasium.V1.ListModelRecordsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_records, 1,
    repeated: true,
    type: Proto.Gymnasium.V1.Dimensions.Model,
    json_name: "modelRecords"
end

defmodule Proto.Gymnasium.V1.CreateModelRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_id, 1, type: :string, json_name: "projectId"
  field :description, 2, type: :string
  field :name, 3, type: :string
  field :slug, 4, type: :string
end

defmodule Proto.Gymnasium.V1.CreateModelRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_record, 1, type: Proto.Gymnasium.V1.Dimensions.Model, json_name: "modelRecord"
end

defmodule Proto.Gymnasium.V1.GetModelRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
  field :model_slug, 2, type: :string, json_name: "modelSlug"
  field :preload_attributes, 3, type: :bool, json_name: "preloadAttributes"
  field :preload_associations, 4, type: :bool, json_name: "preloadAssociations"
end

defmodule Proto.Gymnasium.V1.GetModelRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_record, 1, type: Proto.Gymnasium.V1.Dimensions.Model, json_name: "modelRecord"

  field :model_association_records, 2,
    repeated: true,
    type: Proto.Gymnasium.V1.Dimensions.ModelAssociation,
    json_name: "modelAssociationRecords"

  field :model_attribute_records, 3,
    repeated: true,
    type: Proto.Gymnasium.V1.Dimensions.ModelAttribute,
    json_name: "modelAttributeRecords"
end

defmodule Proto.Gymnasium.V1.DeleteModelRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
end

defmodule Proto.Gymnasium.V1.DeleteModelRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"
end

defmodule Proto.Gymnasium.V1.CreateModelAttributeRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_id, 1, type: :string, json_name: "modelId"
  field :description, 2, type: :string
  field :kind, 3, type: Proto.Gymnasium.V1.Dimensions.ModelAttributeKind, enum: true
  field :name, 4, type: :string
end

defmodule Proto.Gymnasium.V1.CreateModelAttributeRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_attribute_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.ModelAttribute,
    json_name: "modelAttributeRecord"
end

defmodule Proto.Gymnasium.V1.GetModelAttributeRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
  field :model_slug, 2, type: :string, json_name: "modelSlug"
  field :attribute_name, 3, type: :string, json_name: "attributeName"
end

defmodule Proto.Gymnasium.V1.GetModelAttributeRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_attribute_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.ModelAttribute,
    json_name: "modelAttributeRecord"
end

defmodule Proto.Gymnasium.V1.DeleteModelAttributeRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
end

defmodule Proto.Gymnasium.V1.DeleteModelAttributeRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"
end

defmodule Proto.Gymnasium.V1.CreateModelAssociationRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_id, 1, type: :string, json_name: "modelId"
  field :associated_model_id, 2, type: :string, json_name: "associatedModelId"
  field :description, 3, type: :string
  field :kind, 4, type: Proto.Gymnasium.V1.Dimensions.ModelAssociationKind, enum: true
  field :name, 5, type: :string
end

defmodule Proto.Gymnasium.V1.CreateModelAssociationRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_Association_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.ModelAssociation,
    json_name: "modelAssociationRecord"
end

defmodule Proto.Gymnasium.V1.GetModelAssociationRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
  field :model_slug, 2, type: :string, json_name: "modelSlug"
  field :association_name, 3, type: :string, json_name: "associationName"
end

defmodule Proto.Gymnasium.V1.GetModelAssociationRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_Association_record, 1,
    type: Proto.Gymnasium.V1.Dimensions.ModelAssociation,
    json_name: "modelAssociationRecord"
end

defmodule Proto.Gymnasium.V1.DeleteModelAssociationRecordRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
end

defmodule Proto.Gymnasium.V1.DeleteModelAssociationRecordResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"
end

defmodule Proto.Gymnasium.V1.Dimensions.Service do
  @moduledoc false

  use GRPC.Service, name: "proto.gymnasium.v1.Dimensions", protoc_gen_elixir_version: "0.12.0"

  rpc :ListProjectRecords,
      Proto.Gymnasium.V1.ListProjectRecordsRequest,
      Proto.Gymnasium.V1.ListProjectRecordsResponse

  rpc :GetProjectRecord,
      Proto.Gymnasium.V1.GetProjectRecordRequest,
      Proto.Gymnasium.V1.GetProjectRecordResponse

  rpc :CreateProjectRecord,
      Proto.Gymnasium.V1.CreateProjectRecordRequest,
      Proto.Gymnasium.V1.CreateProjectRecordResponse

  rpc :ArchiveProjectRecord,
      Proto.Gymnasium.V1.ArchiveProjectRecordRequest,
      Proto.Gymnasium.V1.ArchiveProjectRecordResponse

  rpc :RestoreProjectRecord,
      Proto.Gymnasium.V1.RestoreProjectRecordRequest,
      Proto.Gymnasium.V1.RestoreProjectRecordResponse

  rpc :DeleteProjectRecord,
      Proto.Gymnasium.V1.DeleteProjectRecordRequest,
      Proto.Gymnasium.V1.DeleteProjectRecordResponse

  rpc :RenameProjectRecord,
      Proto.Gymnasium.V1.RenameProjectRecordRequest,
      Proto.Gymnasium.V1.RenameProjectRecordResponse

  rpc :ListModelRecords,
      Proto.Gymnasium.V1.ListModelRecordsRequest,
      Proto.Gymnasium.V1.ListModelRecordsResponse

  rpc :CreateModelRecord,
      Proto.Gymnasium.V1.CreateModelRecordRequest,
      Proto.Gymnasium.V1.CreateModelRecordResponse

  rpc :GetModelRecord,
      Proto.Gymnasium.V1.GetModelRecordRequest,
      Proto.Gymnasium.V1.GetModelRecordResponse

  rpc :DeleteModelRecord,
      Proto.Gymnasium.V1.DeleteModelRecordRequest,
      Proto.Gymnasium.V1.DeleteModelRecordResponse

  rpc :CreateModelAttributeRecord,
      Proto.Gymnasium.V1.CreateModelAttributeRecordRequest,
      Proto.Gymnasium.V1.CreateModelAttributeRecordResponse

  rpc :GetModelAttributeRecord,
      Proto.Gymnasium.V1.GetModelAttributeRecordRequest,
      Proto.Gymnasium.V1.GetModelAttributeRecordResponse

  rpc :DeleteModelAttributeRecord,
      Proto.Gymnasium.V1.DeleteModelAttributeRecordRequest,
      Proto.Gymnasium.V1.DeleteModelAttributeRecordResponse

  rpc :CreateModelAssociationRecord,
      Proto.Gymnasium.V1.CreateModelAssociationRecordRequest,
      Proto.Gymnasium.V1.CreateModelAssociationRecordResponse

  rpc :GetModelAssociationRecord,
      Proto.Gymnasium.V1.GetModelAssociationRecordRequest,
      Proto.Gymnasium.V1.GetModelAssociationRecordResponse

  rpc :DeleteModelAssociationRecord,
      Proto.Gymnasium.V1.DeleteModelAssociationRecordRequest,
      Proto.Gymnasium.V1.DeleteModelAssociationRecordResponse
end

defmodule Proto.Gymnasium.V1.Dimensions.Stub do
  @moduledoc false

  use GRPC.Stub, service: Proto.Gymnasium.V1.Dimensions.Service
end