class ShowClassDiagramPage
  attr_reader :project

  attr_reader :model

  attr_reader :class_diagram

  def initialize(project_slug, model_slug)
    @project = ProjectsDataProvider.new.get_project(project_slug)

    if model_slug
      response = ModelsDataProvider.new.get_model(project_slug, model_slug)
      @model = response[:model]
      @class_diagram = ModelsDataProvider.new.get_model_class_diagram(project_slug, model_slug)
    else
      @class_diagram = ModelsDataProvider.new.get_project_class_diagram(project_slug)
    end
  end
end
