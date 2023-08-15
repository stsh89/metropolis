class IndexProjectsArchivePage
  attr_reader :projects

  def initialize
    @projects = ProjectsDataProvider.new.list_archived_projects
  end
end
