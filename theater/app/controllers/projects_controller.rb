class ProjectsController < ApplicationController
  # before_action :set_project, only: %i[ show edit update destroy ]

  # GET /projects
  def index
    @page = IndexProjectPage.new
  end

  # GET /projects/food-service
  def show
    @page = ShowProjectPage.new(params[:id])
  end

  # GET /projects/new
  def new
    @page = NewProjectPage.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @page = CreateProjectPage.new(project_params)

    if @page.create_project
      redirect_to projects_path, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    @page = UpdateProjectPage.new(params[:id], params[:project])

    if @page.update_project
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  # DELETE /projects/1
  def destroy
    # @project.destroy
    # redirect_to projects_url, notice: "Project was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_project
    #   @project = Project.find(params[:id])
    # end

    # Only allow a list of trusted parameters through.
    def project_params
      params.fetch(:project, {}).permit(:name, :description)
    end
end
