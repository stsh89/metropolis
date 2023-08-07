require_relative './gymnasium/server'

class Config
  module Gymnasium
    Config = Struct.new(
      :server,
      keyword_init: true
    )
  end
end
