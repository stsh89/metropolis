class ModelAttribute
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :description

  attr_accessor :name

  attr_accessor :kind

  validates :name, :kind, presence: true

  def id
    @name
  end

  def persisted?
    id.present?
  end

  def save(project, model)
    if self.valid?
      proto_attribute = ProjectsApi
        .new
        .create_model_attribute(project, model, self)
        .model_attribute

      ModelAttribute.from_proto(proto_attribute)
    else
      false
    end
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
        kind: kind_from_proto(proto_attribute.kind)
      )
    end

    private

    def kind_from_proto(proto_kind)
      case proto_kind
      when :MODEL_ATTRIBUTE_KIND_STRING
        "string"
      when :MODEL_ATTRIBUTE_KIND_INTEGER
        "integer"
      when :MODEL_ATTRIBUTE_KIND_BOOLEAN
        "boolean"
      end
    end
  end
end
