class DeleteModelAssociationPage
  def initialize(project_slug:, model_slug:, model_association_name:)
    @project_slug = project_slug
    @model_slug = model_slug
    @model_association_name = model_association_name
  end

  def delete_model_association
    ModelAssociationDataProvider.new.delete_model_association(
      project_slug: @project_slug,
      model_slug: @model_slug,
      model_association_name: @model_association_name
    )

    true
  end
end
