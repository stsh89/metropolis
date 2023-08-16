class ModelAssociationsController < ApplicationController\
  # GET /projects/books-store/models/book/model_association/new
  def new
    @page = NewModelAssociationPage.new(params[:project_id], params[:model_id])
  end

  # POST /projects/book-store/models/book/model_association
  def create
    @page = CreateModelAssociationPage.new(model_association_params.to_h)

    if @page.create_model_association
      redirect_to project_model_path(params[:project_id], params[:model_id]), notice: "Model association was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /projects/book-store/models/boolk/model_attributes
  def destroy
    @page = DeleteModelAssociationPage.new(
      project_slug: params[:project_id],
      model_slug: params[:model_id],
      model_association_name: params[:model_association][:name]
    )

    if @page.delete_model_association
      redirect_to project_model_path(params[:project_id], params[:model_id])
    else
      redirect_to project_model_path(params[:project_id], params[:model_id])
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def model_association_params
    params
      .fetch(:model_association, {})
      .permit(
        :project_slug,
        :model_slug,
        :associated_model_slug,
        :description,
        :kind,
        :name,
      )
  end
end
