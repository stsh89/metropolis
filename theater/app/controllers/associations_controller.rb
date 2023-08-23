class AssociationsController < ApplicationController
  before_action :set_project, only: %i[ new create destroy ]
  before_action :set_model, only: %i[ new create destroy ]

  # GET /projects/book-store/models/book/associations/new
  def new
    @association = ModelAssociation.new
  end

  # POST /projects/book-store/models/book/associations
  def create
    @association = ModelAssociation.new(association_params)

    if @association.save(@project, @model)
      redirect_to project_model_path(@project, @model), notice: "Association was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /projects/book-store/models/book/associations/title
  def destroy
    @model.destroy_association(@project, params[:id])
    redirect_to project_model_path(@project, @model), notice: "Association was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @model = @project.find_model(params[:model_id])
    end

    # Only allow a list of trusted parameters through.
    def association_params
      params.require(:model_association).permit(:name, :description, :kind, :associated_model_slug)
    end
end
