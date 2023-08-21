defmodule GymnasiumGrpc.ModelService.ListProjectModelAssociationsAttributes do
  @moduledoc false

  defstruct project_slug: "",
            model_slug: ""

  @type t() :: %__MODULE__{
          project_slug: String.t(),
          model_slug: String.t()
        }
end
