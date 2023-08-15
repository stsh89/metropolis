class ModelAssociationsController < ApplicationController\
  # GET /projects/books-store/models/book/model_association/new
  def new
    @page = NewModelAssociationPage.new(params[:project_id], params[:model_id])
  end
end
