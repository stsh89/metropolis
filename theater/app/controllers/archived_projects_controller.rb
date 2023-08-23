class ArchivedProjectsController < ApplicationController
  before_action :set_plan, only: %i[ show update destroy ]

  # GET /archived_projects
  def index
    @projects = Plan.archived
  end

  # GET /archived_projects/book-store
  def show
  end

  # DELETE /archived_projects/book-store
  def destroy
    @project.destroy
    redirect_to plans_url, notice: "Plan was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @project = Plan.find(params[:id])
    end
end
