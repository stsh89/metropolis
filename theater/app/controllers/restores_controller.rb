class RestoresController < ApplicationController
  before_action :set_project, only: %i[ show update ]

  # PATCH/PUT /projects/books-store/restore
  def update
    if @project.restore
      redirect_to plan_path(@project), notice: "Project was successfully restored."
    else
      redirect_to archived_project_path(@project), error: "Project restoration failed."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Plan.find(params[:plan_id])
    end
end
