class NewModelAssociationPage
  attr_reader :project

  attr_reader :model

  def initialize(project_slug, model_slug)
    @project = ProjectsDataProvider.new.get_project(project_slug)

    response = ModelsDataProvider.new.get_model(project_slug, model_slug)
    @model = response[:model]
  end
end
