class ModelAssociation
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :description, :name, :kind, :associated_model_slug, :model

  validates :name, :kind, :associated_model_slug, presence: true

  def id
    @name
  end

  def persisted?
    id.present?
  end

  def save(project, model)
    return if invalid?

    proto_association = ProjectsApi.new.create_model_association(project, model, self).model_association
    ModelAssociation.from_proto(proto_association)
  end

  def destroy(project)
    ProjectsApi
      .new
      .delete_model(project, self)
  end

  class << self
    # rubocop:todo Metrics/MethodLength
    def from_proto(proto_association)
      ModelAssociation.new(
        description: proto_association.description,
        kind: kind_from_proto(proto_association.kind),
        model: Model.from_proto(proto_association.model),
        name: proto_association.name,
      )
    end
    # rubocop:enable Metrics/MethodLength

    private

    def kind_from_proto(proto_kind)
      {
        MODEL_ASSOCIATION_KIND_BELONGS_TO: "belongs_to",
        MODEL_ASSOCIATION_KIND_HAS_ONE: "has_one",
        MODEL_ASSOCIATION_KIND_HAS_MANY: "has_many",
      }.fetch(proto_kind, "belongs_to")
    end
  end
end
