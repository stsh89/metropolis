class ArchivedProjectsController < ApplicationController
  before_action :set_project, only: %i[show destroy]

  # GET /archived_projects
  def index
    @projects = Project.archived
  end

  # GET /archived_projects/book-store
  def show; end

  # DELETE /archived_projects/book-store
  def destroy
    @project.destroy
    redirect_to archived_projects_url, notice: I18n.t("projects.destroyed"), status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end
end
