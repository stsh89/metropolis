defmodule GymnasiumGrpc.ProjectService.RenameProjectAttributes do
  defstruct id: "",
            name: "",
            slug: ""

  @type t() :: %__MODULE__{
          id: Ecto.UUID.t(),
          name: String.t(),
          slug: String.t()
        }
end
