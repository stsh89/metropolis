class Config
  TempleConfig = Struct.new(
    :server,
    keyword_init: true
  )

  TempleServerConfig = Struct.new(
    :address,
    :port,
    keyword_init: true
  )
end
