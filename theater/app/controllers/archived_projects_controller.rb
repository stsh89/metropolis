class ArchivedProjectsController < ApplicationController
  before_action :set_project, only: %i[ show update destroy ]

  # GET /archived_projects
  def index
    @projects = Project.archived
  end

  # GET /archived_projects/book-store
  def show
  end

  # DELETE /archived_projects/book-store
  def destroy
    @project.destroy
    redirect_to projects_url, notice: "Project was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end
end
