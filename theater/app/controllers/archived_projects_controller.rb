class ArchivedProjectsController < ApplicationController
  # GET /archived-projects
  def index
    @page = IndexProjectsArchivePage.new
  end

  # PATCH/PUT /archived-projects/data-store
  def update
    @page = UpdateArchivedProjectPage.new(params[:id], params[:project])

    if @page.update_project
      redirect_to project_path(params[:id])
    else
      redirect_to root_path
    end
  end

  # DELETE /archived-projects/data-store
  def destroy
    @page = DeleteArchivedProjectPage.new(params[:id])

    if @page.delete_project
      redirect_to projects_path
    else
      redirect_to projects_path
    end
  end
end
