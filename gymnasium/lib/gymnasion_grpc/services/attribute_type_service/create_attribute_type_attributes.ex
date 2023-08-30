defmodule GymnasiumGrpc.AttributeTypeService.CreateAttributeTypeAttributes do
  @moduledoc false

  defstruct description: "",
            name: "",
            slug: ""

  @type t() :: %__MODULE__{
          description: String.t(),
          name: String.t(),
          slug: String.t()
        }
end
