class RestoresController < ApplicationController
  before_action :set_project, only: %i[update]

  # PATCH/PUT /projects/books-store/restore
  def update
    if @project.restore
      redirect_to project_path(@project), notice: I18n.t("projects.restored")
    else
      redirect_to archived_project_path(@project), error: "Project restoration failed."
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:project_id])
  end
end
