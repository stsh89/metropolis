class ModelAttribute
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :description, :name, :attribute_type_slug, :attribute_type

  validates :name, :attribute_type_slug, presence: true

  def id
    @name
  end

  def persisted?
    id.present?
  end

  def save(project, model)
    return if invalid?

    proto_attribute = ProjectsApi.new.create_model_attribute(project, model, self).model_attribute
    ModelAttribute.from_proto(proto_attribute)
  end

  def destroy(project)
    ProjectsApi
      .new
      .delete_model(project, self)
  end

  class << self
    def from_proto(proto_attribute)
      ModelAttribute.new(
        description: proto_attribute.description,
        name: proto_attribute.name,
        attribute_type: AttributeTypeApiConverter.to_model(proto_attribute.type),
      )
    end
  end
end
