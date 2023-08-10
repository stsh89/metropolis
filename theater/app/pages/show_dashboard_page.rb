class ShowDashboardPage
  attr_reader :projects

  def initialize
    @projects = ProjectsDataProvider.new.showcase_projects
  end
end
