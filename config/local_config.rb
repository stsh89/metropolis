require 'json'
require_relative './lib/temple_config'

class Config
  Attributes = Struct.new(
    :temple_config,
    keyword_init: true
  )

  def initialize(attributes)
    @attributes = attributes
  end

  def generate
    file_content = JSON.pretty_generate(
      temple_config: @attributes.temple_config.to_h
    )

    File.write('local_config.json', file_content)
  end
end

Config.new(
  Config::Attributes.new(
    temple_config: TempleConfig.new(TempleConfig::Attributes.new(
      server: TempleConfig::Server.new(
        address: '[::1]',
        port: '50051'
      )
    ))
  )
).generate
