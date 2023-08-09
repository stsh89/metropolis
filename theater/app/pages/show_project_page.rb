class ShowProjectPage
  attr_reader :project

  def initialize(project_slug)
    @project = ProjectsDataProvider.new.check_project_details(project_slug)
  end
end
