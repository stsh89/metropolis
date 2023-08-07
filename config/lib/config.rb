require 'json'

require_relative './config/file'
require_relative './config/temple'
require_relative './config/gymnasium'

class Config
  Config = Struct.new(
    :temple,
    :gymnasium,
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
        temple: Temple::Config.new(
          server: Temple::Server.new(
            address: '[::1]',
            port: '50051'
          )
        ),
        gymnasium: Gymnasium::Config.new(
          server: Gymnasium::Server.new(
            address: '127.0.0.1',
            port: '50052'
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
