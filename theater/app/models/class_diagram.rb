class ClassDiagram
  include ActiveModel::API

  attr_accessor :code

  class << self
    def for_project(project)
      diagram = ProjectsApi
        .new
        .get_project_class_diagram(project)
        .diagram

      ClassDiagram.new(code: diagram)
    end

    def for_model(project, model)
      diagram = ProjectsApi
        .new
        .get_model_class_diagram(project, model)
        .diagram

      ClassDiagram.new(code: diagram)
    end
  end
end
