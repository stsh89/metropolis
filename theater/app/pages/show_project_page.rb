class ShowProjectPage
  attr_reader :project
  attr_reader :models

  def initialize(project_slug)
    @project = ProjectsDataProvider.new.get_project(project_slug)
    @models = ModelsDataProvider.new.list_models(project_slug)
  end
end
