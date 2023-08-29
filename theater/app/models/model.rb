class Model
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :description, :name, :slug, :attributes, :associations

  validates :name, presence: true

  def id
    @slug
  end

  def persisted?
    id.present?
  end

  def save(project)
    return if invalid?

    proto_model = ProjectsApi.new.create_model(project, self).model
    self.slug = proto_model.slug
    Model.from_proto(proto_model)
  end

  def destroy(project)
    ProjectsApi
      .new
      .delete_model(project, self)
  end

  def destroy_attribute(project, attribute_name)
    ProjectsApi
      .new
      .delete_model_attribute(project, self, attribute_name)
  end

  def destroy_association(project, association_name)
    ProjectsApi
      .new
      .delete_model_association(project, self, association_name)
  end

  class << self
    def from_proto(proto_model)
      Model.new(
        description: proto_model.description,
        name: proto_model.name,
        slug: proto_model.slug,
      )
    end
  end
end
