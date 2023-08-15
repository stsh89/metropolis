class ModelsController < ApplicationController\
  # GET /projects/books-store/models/new
  def new
    @page = NewModelPage.new(params[:project_id])
  end

  # POST /projects/data-store/models
  def create
    @page = CreateModelPage.new(params[:project_id], model_params)

    if @page.create_model
      redirect_to project_model_path(params[:project_id], @page.model.slug), notice: "Model was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /projects/book-store/models/book
  def show
    @page = ShowModelPage.new(params[:project_id], params[:id])
  end

  private

  # Only allow a list of trusted parameters through.
  def model_params
    params.fetch(:model, {}).permit(:name, :description)
  end
end
