class ArchivedProjectsController < ApplicationController
  # GET /archived-projects
  def index
    @page = IndexProjectsArchivePage.new
  end

  # PATCH/PUT /archived-projects/1
  def update
    @page = UpdateArchivedProjectPage.new(params[:id], params[:project])

    if @page.update_project
      redirect_to root_path
    else
      redirect_to root_path
    end
  end
end
