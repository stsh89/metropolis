defmodule GymnasiumGrpc.ModelService.CreateAttributeAttributes do
  defstruct model_id: "",
            description: "",
            name: "",
            kind: ""

  @type t() :: %__MODULE__{
          model_id: Ecto.UUID.t(),
          description: String.t(),
          name: String.t(),
          kind: String.t()
        }
end
