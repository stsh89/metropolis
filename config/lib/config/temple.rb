require_relative './temple/server'

class Config
  module Temple
    Config = Struct.new(
      :server,
      keyword_init: true
    )
  end
end
