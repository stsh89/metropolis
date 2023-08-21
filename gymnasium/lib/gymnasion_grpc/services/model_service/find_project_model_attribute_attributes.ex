defmodule GymnasiumGrpc.ModelService.FindProjectModelAttributeAttributes do
  defstruct project_slug: "",
            model_slug: "",
            attribute_name: ""

  @type t() :: %__MODULE__{
          project_slug: String.t(),
          model_slug: String.t(),
          attribute_name: String.t()
        }
end
