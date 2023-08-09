class IndexProjectsArchivePage
  attr_reader :projects

  def initialize
    @projects = ProjectsDataProvider.new.inquire_archived_projects
  end
end
