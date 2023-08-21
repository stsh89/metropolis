defmodule GymnasiumGrpc.ModelService.FindProjectModelAssociationAttributes do
  defstruct project_slug: "",
            model_slug: "",
            association_name: ""

  @type t() :: %__MODULE__{
          project_slug: String.t(),
          model_slug: String.t(),
          association_name: String.t()
        }
end
