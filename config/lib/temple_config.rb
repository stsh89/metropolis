TempleConfig = Struct.new(
  :server,
  keyword_init: true
) do
  def to_h
    { server: server.to_h }
  end
end

TempleServerConfig = Struct.new(
  :address,
  :port,
  keyword_init: true
)
