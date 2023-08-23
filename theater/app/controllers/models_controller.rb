class ModelsController < ApplicationController
  before_action :set_plan, only: %i[ create index new show edit update destroy ]
  before_action :set_model, only: %i[ show destroy ]

  # GET /projects/book-store/models
  def index
    @models = @plan.models
  end

  # GET /projects/book-store/models/book
  def show
  end

  # GET /projects/book-store/new
  def new
    @model = Model.new
  end

  # POST /projects/book-store/models
  def create
    @model = Model.new(model_params)

    if @model.save(@plan)
      redirect_to plan_model_path(@plan, @model), notice: "Model was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /projects/book-store/models/book
  def destroy
    @model.destroy(@plan)
    redirect_to plan_models_path(@plan), notice: "Model was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:plan_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @model = @plan.find_model(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def model_params
      params.require(:model).permit(:name, :description)
    end
end
