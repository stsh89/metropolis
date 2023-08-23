class ModelAssociation
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :description

  attr_accessor :name

  attr_accessor :kind

  attr_accessor :associated_model_slug

  attr_accessor :model

  validates :name, :kind, :associated_model_slug, presence: true

  def id
    @name
  end

  def persisted?
    id.present?
  end

  def save(project, model)
    puts(self.associated_model_slug)
    if self.valid?
      proto_association = ProjectsApi
        .new
        .create_model_association(project, model, self)
        .model_association

      ModelAssociation.from_proto(proto_association)
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
    def from_proto(proto_association)
      ModelAssociation.new(
        description: proto_association.description,
        kind: kind_from_proto(proto_association.kind),
        model: Model.from_proto(proto_association.model),
        name: proto_association.name
      )
    end

    private

    def kind_from_proto(proto_kind)
      case proto_kind
      when :MODEL_ASSOCIATION_KIND_BELONGS_TO
        "belongs_to"
      when :MODEL_ASSOCIATION_KIND_HAS_ONE
        "has_one"
      when :MODEL_ASSOCIATION_KIND_HAS_MANY
        "has_many"
      end
    end
  end
end
