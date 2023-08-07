class Config
  module Temple
    Server = Struct.new(
      :address,
      :port,
      keyword_init: true
    )
  end
end
