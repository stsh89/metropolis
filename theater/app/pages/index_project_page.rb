class IndexProjectPage
  attr_reader :projects

  def initialize
    @projects = ProjectsDataProvider.new.list_projects
  end
end
