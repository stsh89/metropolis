require_relative '../helpers/structure_helper'

class Config
  class File
    def initialize(config)
      @config = config
    end

    def write
      config_hash = StructureHelper.structure_to_hash(@config)
      file_content = JSON.pretty_generate(config_hash)

      ::File.write('config.json', file_content)
    end
  end
end
