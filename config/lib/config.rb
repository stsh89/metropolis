require 'json'

require_relative './config/file'
require_relative './config/temple_config'

class Config
  Config = Struct.new(
    :temple,
    keyword_init: true
  )

  class << self
    def write_to_file(environment)
      validate_environment(environment)

      ::Config::File.new(send(environment)).write
    end

    def supported_environments
      %w[local]
    end

    private

    def local
      Config.new(
        temple: TempleConfig.new(
          server: TempleServerConfig.new(
            address: '[::1]',
            port: '50051'
          )
        )
      )
    end

    def validate_environment(environment)
      return if supported_environments.include?(environment)

      raise "unsupported config environment: `#{environment}`"
    end
  end
end
