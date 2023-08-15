class CreateModelAttributePage
  attr_reader :model_attribute

  def initialize(project_slug, model_slug, params)
    @project_slug = project_slug
    @model_slug = model_slug
    @params = params
  end

  def create_model_attribute
    @model_attribute = ModelAttributeDataProvider.new.create_model_attribute(
      @params.merge(
        model_slug: @model_slug,
        project_slug: @project_slug
      )
    )
  end
end
