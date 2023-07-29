module EnvConfig
  Config = Struct.new(
    :projects_client,
    keyword_init: true
  )

  ProjectsClient = Struct.new(
    :address,
    :port,
    keyword_init: true
  )

  class Loader
    class << self
      def load
        file_content = File.read("#{Rails.root}/../local_config.json")
        json = JSON.parse(file_content)

        temple_config_json = json['temple_config']
        temple_server_config_json = temple_config_json['server']
        projects_client = ProjectsClient.new(
          address: temple_server_config_json['address'],
          port: temple_server_config_json['port']
        )

        Config.new(
          projects_client: projects_client
        )
      end
    end
  end
end

TheaterConfig = EnvConfig::Loader.load
