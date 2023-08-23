class ClassDiagramsController < ApplicationController
  before_action :set_project, only: %i[ show ]
  before_action :set_model, only: %i[ show ]
  before_action :set_class_diagram, only: %i[ show ]

  # GET /projects/books-store/models/book/class_diagram
  # or
  # GET /projects/books-store/class_diagram
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_model
      return if params[:model_id].blank?

      @model = @project.find_model(params[:model_id])
    end

    def set_class_diagram
      @class_diagram = if @model
        ClassDiagram.for_model(@project, @model)
      else
        ClassDiagram.for_project(@project)
      end
    end
end
