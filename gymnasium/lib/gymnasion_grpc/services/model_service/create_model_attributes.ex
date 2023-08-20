defmodule GymnasiumGrpc.ModelService.CreateModelAttributes do
  defstruct project_id: "",
            description: "",
            name: "",
            slug: ""

  @type t() :: %__MODULE__{
          project_id: Ecto.UUID.t(),
          description: String.t(),
          name: String.t(),
          slug: String.t()
        }
end
