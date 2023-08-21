defmodule GymnasiumGrpc.ProjectService.CreateProjectAttributes do
  @moduledoc false

  defstruct archived_at: nil,
            description: "",
            name: "",
            slug: ""

  @type t() :: %__MODULE__{
          archived_at: Calendar.datetime() | nil,
          description: String.t(),
          name: String.t(),
          slug: String.t()
        }
end
