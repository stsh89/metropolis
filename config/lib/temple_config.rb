class TempleConfig
  Attributes = Struct.new(
    :server,
    keyword_init: true
  )

  Server = Struct.new(
    :address,
    :port,
    keyword_init: true
  )

  def initialize(attributes)
    @attributes = attributes
  end

  def to_h
    {
      server: {
        address: @attributes.server.address,
        port: @attributes.server.port
      }
    }
  end
end
