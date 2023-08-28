class ModelsController < ApplicationController
  before_action :set_project, only: %i[create index new show destroy]

  before_action :set_model, only: %i[show destroy]

  before_action :initialize_model, only: :create

  # GET /projects/book-store/models
  def index
    @models = @project.models
  end

  # GET /projects/book-store/models/book
  def show; end

  # GET /projects/book-store/new
  def new
    @model = Model.new
  end

  # POST /projects/book-store/models
  def create
    if @model.save(@project)
      redirect_to project_model_path(@project, @model), notice: I18n.t("models.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /projects/book-store/models/book
  def destroy
    @model.destroy(@project)
    redirect_to @project, notice: I18n.t("models.destroyed"), status: :see_other
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

  def initialize_model
    @model = Model.new(model_params)
  end

  # Only allow a list of trusted parameters through.
  def model_params
    params.require(:model).permit(:name, :description)
  end
end
