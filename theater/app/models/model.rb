class Model
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :description

  attr_accessor :name

  attr_accessor :slug

  attr_accessor :attributes

  attr_accessor :associations

  validates :name, presence: true

  def id
    @slug
  end

  def persisted?
    id.present?
  end

  def save(project)
    if self.valid?
      proto_model = ProjectsApi
        .new
        .create_model(project, self)
        .model

      model = Model.from_proto(proto_model)
      self.slug = model.slug
    else
      false
    end
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
        slug: proto_model.slug
      )
    end
  end
end
