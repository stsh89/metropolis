class NewModelAssociationPage
  attr_reader :project

  attr_reader :model

  attr_reader :models

  def initialize(project_slug, model_slug)
    @project = ProjectsDataProvider.new.get_project(project_slug)

    response = ModelsDataProvider.new.get_model(project_slug, model_slug)
    @model = response[:model]

    @models = ModelsDataProvider.new.list_models(project_slug)
  end
end
