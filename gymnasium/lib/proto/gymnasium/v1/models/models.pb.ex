defmodule Proto.Gymnasium.V1.Models.AttributeKind do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :ATTRIBUTE_KIND_UNSPECIFIED, 0
  field :ATTRIBUTE_KIND_STRING, 1
  field :ATTRIBUTE_KIND_INTEGER, 2
  field :ATTRIBUTE_KIND_BOOLEAN, 3
end

defmodule Proto.Gymnasium.V1.Models.AssociationKind do
  @moduledoc false

  use Protobuf, enum: true, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :ASSOCIATION_KIND_UNSPECIFIED, 0
  field :ASSOCIATION_KIND_BELONGS_TO, 1
  field :ASSOCIATION_KIND_HAS_ONE, 2
  field :ASSOCIATION_KIND_HAS_MANY, 3
end

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

defmodule Proto.Gymnasium.V1.Models.Association do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
  field :model_id, 2, type: :string, json_name: "modelId"
  field :associated_model, 3, type: Proto.Gymnasium.V1.Models.Model, json_name: "associatedModel"
  field :description, 4, type: :string
  field :kind, 5, type: Proto.Gymnasium.V1.Models.AssociationKind, enum: true
  field :name, 6, type: :string
  field :create_time, 7, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :update_time, 8, type: Google.Protobuf.Timestamp, json_name: "updateTime"
end

defmodule Proto.Gymnasium.V1.Models.Attribute do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
  field :model_id, 2, type: :string, json_name: "modelId"
  field :description, 3, type: :string
  field :kind, 4, type: Proto.Gymnasium.V1.Models.AttributeKind, enum: true
  field :name, 5, type: :string
  field :create_time, 6, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :update_time, 7, type: Google.Protobuf.Timestamp, json_name: "updateTime"
end

defmodule Proto.Gymnasium.V1.Models.ModelOverview do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model, 1, type: Proto.Gymnasium.V1.Models.Model
  field :associations, 2, repeated: true, type: Proto.Gymnasium.V1.Models.Association
  field :attributes, 3, repeated: true, type: Proto.Gymnasium.V1.Models.Attribute
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

defmodule Proto.Gymnasium.V1.Models.FindProjectModelOverviewRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
  field :model_slug, 2, type: :string, json_name: "modelSlug"
end

defmodule Proto.Gymnasium.V1.Models.ListProjectModelOverviewsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
end

defmodule Proto.Gymnasium.V1.Models.ListProjectModelOverviewsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_overviews, 1,
    repeated: true,
    type: Proto.Gymnasium.V1.Models.ModelOverview,
    json_name: "modelOverviews"
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

defmodule Proto.Gymnasium.V1.Models.CreateAttributeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_id, 1, type: :string, json_name: "modelId"
  field :description, 2, type: :string
  field :kind, 3, type: Proto.Gymnasium.V1.Models.AttributeKind, enum: true
  field :name, 4, type: :string
end

defmodule Proto.Gymnasium.V1.Models.CreateAssociationRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :model_id, 1, type: :string, json_name: "modelId"
  field :associated_model_id, 2, type: :string, json_name: "associatedModelId"
  field :description, 3, type: :string
  field :kind, 4, type: Proto.Gymnasium.V1.Models.AssociationKind, enum: true
  field :name, 5, type: :string
end

defmodule Proto.Gymnasium.V1.Models.FindProjectModelAttributeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
  field :model_slug, 2, type: :string, json_name: "modelSlug"
  field :attribute_name, 3, type: :string, json_name: "attributeName"
end

defmodule Proto.Gymnasium.V1.Models.FindProjectModelAssociationRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
  field :model_slug, 2, type: :string, json_name: "modelSlug"
  field :association_name, 3, type: :string, json_name: "associationName"
end

defmodule Proto.Gymnasium.V1.Models.ListProjectModelAttributesRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
  field :model_slug, 2, type: :string, json_name: "modelSlug"
end

defmodule Proto.Gymnasium.V1.Models.ListProjectModelAssociationsRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :project_slug, 1, type: :string, json_name: "projectSlug"
  field :model_slug, 2, type: :string, json_name: "modelSlug"
end

defmodule Proto.Gymnasium.V1.Models.ListProjectModelAttributesResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :attributes, 1, repeated: true, type: Proto.Gymnasium.V1.Models.Attribute
end

defmodule Proto.Gymnasium.V1.Models.ListProjectModelAssociationsResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :associations, 1, repeated: true, type: Proto.Gymnasium.V1.Models.Association
end

defmodule Proto.Gymnasium.V1.Models.DeleteAttributeRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
end

defmodule Proto.Gymnasium.V1.Models.DeleteAssociationRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :id, 1, type: :string
end

defmodule Proto.Gymnasium.V1.Models.Models.Service do
  @moduledoc false

  use GRPC.Service, name: "proto.gymnasium.v1.models.Models", protoc_gen_elixir_version: "0.12.0"

  rpc :CreateModel, Proto.Gymnasium.V1.Models.CreateModelRequest, Proto.Gymnasium.V1.Models.Model

  rpc :FindProjectModel,
      Proto.Gymnasium.V1.Models.FindProjectModelRequest,
      Proto.Gymnasium.V1.Models.Model

  rpc :FindProjectModelOverview,
      Proto.Gymnasium.V1.Models.FindProjectModelOverviewRequest,
      Proto.Gymnasium.V1.Models.ModelOverview

  rpc :ListProjectModelOverviews,
      Proto.Gymnasium.V1.Models.ListProjectModelOverviewsRequest,
      Proto.Gymnasium.V1.Models.ListProjectModelOverviewsResponse

  rpc :ListProjectModels,
      Proto.Gymnasium.V1.Models.ListProjectModelsRequest,
      Proto.Gymnasium.V1.Models.ListProjectModelsResponse

  rpc :DeleteModel, Proto.Gymnasium.V1.Models.DeleteModelRequest, Google.Protobuf.Empty

  rpc :CreateAssociation,
      Proto.Gymnasium.V1.Models.CreateAssociationRequest,
      Proto.Gymnasium.V1.Models.Association

  rpc :FindProjectModelAssociation,
      Proto.Gymnasium.V1.Models.FindProjectModelAssociationRequest,
      Proto.Gymnasium.V1.Models.Association

  rpc :ListProjectModelAssociations,
      Proto.Gymnasium.V1.Models.ListProjectModelAssociationsRequest,
      Proto.Gymnasium.V1.Models.ListProjectModelAssociationsResponse

  rpc :DeleteAssociation,
      Proto.Gymnasium.V1.Models.DeleteAssociationRequest,
      Google.Protobuf.Empty

  rpc :CreateAttribute,
      Proto.Gymnasium.V1.Models.CreateAttributeRequest,
      Proto.Gymnasium.V1.Models.Attribute

  rpc :FindProjectModelAttribute,
      Proto.Gymnasium.V1.Models.FindProjectModelAttributeRequest,
      Proto.Gymnasium.V1.Models.Attribute

  rpc :ListProjectModelAttributes,
      Proto.Gymnasium.V1.Models.ListProjectModelAttributesRequest,
      Proto.Gymnasium.V1.Models.ListProjectModelAttributesResponse

  rpc :DeleteAttribute, Proto.Gymnasium.V1.Models.DeleteAttributeRequest, Google.Protobuf.Empty
end

defmodule Proto.Gymnasium.V1.Models.Models.Stub do
  @moduledoc false

  use GRPC.Stub, service: Proto.Gymnasium.V1.Models.Models.Service
end