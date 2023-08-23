# class ModelAttributesController < ApplicationController\
#   # GET /projects/books-store/models/book/model_attribute/new
#   def new
#     @page = NewModelAttributePage.new(params[:project_id], params[:model_id])
#   end

#   # POST /projects/book-store/models/book/model_attribute
#   def create
#     @page = CreateModelAttributePage.new(params[:project_id], params[:model_id], model_attribute_params)

#     if @page.create_model_attribute
#       redirect_to project_model_path(params[:project_id], params[:model_id]), notice: "Model attribute was successfully created."
#     else
#       render :new, status: :unprocessable_entity
#     end
#   end

#   # DELETE /projects/book-store/models/boolk/model_attributes
#   def destroy
#     @page = DeleteModelAttributePage.new(
#       project_slug: params[:project_id],
#       model_slug: params[:model_id],
#       model_attribute_name: params[:model_attribute][:name]
#     )

#     if @page.delete_model_attribute
#       redirect_to project_model_path(params[:project_id], params[:model_id])
#     else
#       redirect_to project_model_path(params[:project_id], params[:model_id])
#     end
#   end

#   private

#   # Only allow a list of trusted parameters through.
#   def model_attribute_params
#     params.fetch(:model_attribute, {}).permit(:description, :kind, :name)
#   end
# end
