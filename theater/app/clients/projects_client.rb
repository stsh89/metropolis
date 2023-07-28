class ProjectsClient
  def list_projects
    [
      Project.new(
        name: 'Metropolis',
        description: 'Highly specialized Architecture Design and Documentation Tool.',
        create_timestamp: DateTime.parse('2023-07-28 14:23:00')
      ),
      Project.new(
        name: 'Diesel',
        description: 'Safe, Extensible ORM and Query Builder for Rust.',
        create_timestamp: DateTime.parse('2023-07-27 17:11:10')
      ),
      Project.new(
        name: 'Livebook',
        description: 'Livebook is a web application for writing interactive and collaborative code notebooks.',
        create_timestamp: DateTime.parse('2023-07-25 10:11:25')
      ),
    ]
  end
end
