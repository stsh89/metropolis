defmodule GymnasiumGrpc.ModelService.CreateAssociationAttributes do
  defstruct model_id: "",
            associated_model_id: "",
            description: "",
            name: "",
            kind: ""

  @type t() :: %__MODULE__{
          model_id: Ecto.UUID.t(),
          associated_model_id: Ecto.UUID.t(),
          description: String.t(),
          name: String.t(),
          kind: String.t()
        }
end
