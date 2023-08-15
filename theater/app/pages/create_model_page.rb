class CreateModelPage
  attr_reader :model

  def initialize(project_slug, params)
    @project_slug = project_slug
    @params = params
  end

  def create_model
    @model = ModelsDataProvider.new.create_model(@params.merge(project_slug: @project_slug))
  end
end
