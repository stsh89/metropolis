class ShowModelPage
  attr_reader :project

  attr_reader :model

  attr_reader :model_attributes

  attr_reader :model_associations

  def initialize(project_slug, model_slug)
    @project = ProjectsDataProvider.new.get_project(project_slug)

    response = ModelsDataProvider.new.get_model(project_slug, model_slug)

    @model = response[:model]
    @model_attributes = response[:attributes]
    @model_associations = response[:associations]
  end
end
