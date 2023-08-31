defmodule GymnasiumGrpc.ModelService.CreateAttributeAttributes do
  @moduledoc false

  defstruct model_id: "",
            attribute_type_id: "",
            description: "",
            name: "",
            kind: ""

  @type t() :: %__MODULE__{
          model_id: Ecto.UUID.t(),
          attribute_type_id: Ecto.UUID.t(),
          description: String.t(),
          name: String.t(),
          kind: String.t()
        }
end
