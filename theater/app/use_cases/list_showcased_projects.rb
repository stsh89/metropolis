class ListShowcasedProjects
  def initialize(projects_client:)
    @projects_client = projects_client
  end

  def execute
    @projects_client.live_list_projects
  end
end
