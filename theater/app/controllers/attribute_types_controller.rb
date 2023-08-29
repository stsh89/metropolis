class AttributeTypesController < ApplicationController
  before_action :set_attribute_type, only: %i[show edit update destroy]

  before_action :initialize_attribute_type, only: :create

  # GET /attribute_types
  def index
    @attribute_types = AttributeType.all
  end

  # GET /attribute_types/1
  def show; end

  # GET /attribute_types/new
  def new
    @attribute_type = AttributeType.new
  end

  # GET /attribute_types/1/edit
  def edit; end

  # POST /attribute_types
  def create
    if @attribute_type.save
      redirect_to @attribute_type, notice: I18n.t("attribute_types.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attribute_types/1
  def update
    if @attribute_type.update(attribute_type_params)
      redirect_to @attribute_type, notice: I18n.t("attribute_types.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /attribute_types/1
  def destroy
    @attribute_type.destroy
    redirect_to attribute_types_url, notice: I18n.t("attribute_types.destroyed"), status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attribute_type
    @attribute_type = AttributeType.find(params[:id])
  end

  def initialize_attribute_type
    @attribute_type = AttributeType.new(attribute_type_params)
  end

  # Only allow a list of trusted parameters through.
  def attribute_type_params
    params.require(:attribute_type).permit(:name, :description)
  end
end
