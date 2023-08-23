class ArchivesController < ApplicationController
  before_action :set_project, only: %i[ show update ]

  # PATCH/PUT /projects/books-store/archive
  def update
    if @project.archive
      redirect_to archived_project_path(@project), notice: "Project was successfully archived."
    else
      redirect_to @project, error: "Project archivation failed."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end
end
