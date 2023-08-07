class Config
  module Gymnasium
    Server = Struct.new(
      :address,
      :port,
      keyword_init: true
    )
  end
end
