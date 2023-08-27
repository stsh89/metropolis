class AttributeTypesController < ApplicationController
  before_action :set_attribute_type, only: %i[ show edit update destroy ]

  # GET /attribute_types
  def index
    @attribute_types = AttributeType.all
  end

  # GET /attribute_types/1
  def show
  end

  # GET /attribute_types/new
  def new
    @attribute_type = AttributeType.new
  end

  # GET /attribute_types/1/edit
  def edit
  end

  # POST /attribute_types
  def create
    @attribute_type = AttributeType.new(attribute_type_params)

    if @attribute_type.save
      redirect_to @attribute_type, notice: "Attribute type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attribute_types/1
  def update
    if @attribute_type.update(attribute_type_params)
      redirect_to @attribute_type, notice: "Attribute type was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /attribute_types/1
  def destroy
    @attribute_type.destroy
    redirect_to attribute_types_url, notice: "Attribute type was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attribute_type
      @attribute_type = AttributeType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attribute_type_params
      params.require(:attribute_type).permit(:name, :description)
    end
end
