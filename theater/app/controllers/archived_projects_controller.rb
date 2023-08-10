class ArchivedProjectsController < ApplicationController
  # GET /archived-projects
  def index
    @page = IndexProjectsArchivePage.new
  end

  # PATCH/PUT /archived-projects/1
  def update
    @page = UpdateArchivedProjectPage.new(params[:id], params[:project])

    if @page.update_project
      redirect_to project_path(@page.project.slug)
    else
      redirect_to root_path
    end
  end

  # DELETE /archived-projects/1
  def destroy
    @page = DeleteArchivedProjectPage.new(params[:id])

    if @page.delete_project
      redirect_to root_path
    else
      redirect_to root_path
    end
  end
end
