class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update]

  before_action :initialize_project, only: :create

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/book-store
  def show; end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/book-store/edit
  def edit; end

  # POST /projects
  def create
    if @project.save
      redirect_to @project, notice: I18n.t("projects.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/book-store
  def update
    if @project.rename(project_params[:name])
      redirect_to @project, notice: I18n.t("projects.renamed")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  def initialize_project
    @project = Project.new(project_params)
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:name)
  end
end
