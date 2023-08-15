class DeleteModelAttributePage
  def initialize(project_slug:, model_slug:, model_attribute_name:)
    @project_slug = project_slug
    @model_slug = model_slug
    @model_attribute_name = model_attribute_name
  end

  def delete_model_attribute
    ModelAttributeDataProvider.new.delete_model_attribute(
      project_slug: @project_slug,
      model_slug: @model_slug,
      model_attribute_name: @model_attribute_name
    )

    true
  end
end
