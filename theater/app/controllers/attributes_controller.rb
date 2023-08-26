class AttributesController < ApplicationController
  before_action :set_project, only: %i[ new create destroy ]
  before_action :set_model, only: %i[ new create destroy ]

  # GET /projects/book-store/models/book/attributes/new
  def new
    @attribute = ModelAttribute.new
  end

  # POST /projects/book-store/models/book/attributes
  def create
    @attribute = ModelAttribute.new(attribute_params)

    if @attribute.save(@project, @model)
      redirect_to project_model_path(@project, @model), notice: "Attribute was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /projects/book-store/models/book/attributes/title
  def destroy
    @model.destroy_attribute(@project, params[:id])
    redirect_to project_model_path(@project, @model), notice: "Attribute was successfully destroyed.", status: :see_other
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
    def attribute_params
      params.require(:model_attribute).permit(:name, :description, :kind)
    end
end