require 'json'
require_relative './lib/temple_config'

Config = Struct.new(
  :temple,
  keyword_init: true
) do
  def to_h
    {
      temple: temple.to_h
    }
  end
end

class ConfigGenerator
  def initialize(environment)
    unless valid_environments.include?(environment)
      raise "can't generate config for unknown environment: `#{environment}`"
    end

    @environment = environment
  end

  def generate
    config = send("#{@environment}_config")
    file_content = JSON.pretty_generate(config.to_h)
    File.write('config.json', file_content)
  end

  private

  def local_config
    Config.new(
      temple: TempleConfig.new(
        server: TempleServerConfig.new(
          address: '[::1]',
          port: '50051'
        )
      )
    )
  end

  def valid_environments
    ['local']
  end
end

ConfigGenerator.new(ARGV[0]).generate
