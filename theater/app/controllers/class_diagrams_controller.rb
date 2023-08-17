class ClassDiagramsController < ApplicationController
  # GET /projects/books-store/models/book/class_diagram
  def show
    @page = ShowClassDiagramPage.new(params[:project_id], params[:model_id])

    # render inline: @page.class_diagram
  end
end
