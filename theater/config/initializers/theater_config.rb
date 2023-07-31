module Config
  Config = Struct.new(
    :projects_client,
    keyword_init: true
  )

  ProjectsClient = Struct.new(
    :address,
    :port,
    keyword_init: true
  ) do
    def socket_address
      "#{address}:#{port}"
    end
  end

  class Loader
    class << self
      def read_from_file(file_path)
        file_content = File.read(file_path)
        json = JSON.parse(file_content)

        temple_config_json = json['temple']
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

TheaterConfig = Config::Loader.read_from_file("#{Rails.root}/../config.json")
