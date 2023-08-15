class NewModelPage
  attr_reader :project

  attr_reader :model

  def initialize(project_slug)
    @project = ProjectsDataProvider.new.get_project(project_slug)
    @model = Model.new
  end
end
