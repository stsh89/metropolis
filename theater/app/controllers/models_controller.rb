class ModelsController < ApplicationController
  before_action :set_project, only: %i[ create index new show edit update destroy ]
  before_action :set_model, only: %i[ show destroy ]

  # GET /projects/book-store/models
  def index
    @models = @project.models
  end

  # GET /projects/book-store/models/book
  def show
  end

  # GET /projects/book-store/new
  def new
    @model = Model.new
  end

  # POST /projects/book-store/models
  def create
    @model = Model.new(model_params)

    if @model.save(@project)
      redirect_to project_model_path(@project, @model), notice: "Model was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /projects/book-store/models/book
  def destroy
    @model.destroy(@project)
    redirect_to @project, notice: "Model was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @model = @project.find_model(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def model_params
      params.require(:model).permit(:name, :description)
    end
end
