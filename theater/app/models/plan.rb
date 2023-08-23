class Plan
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :description

  attr_accessor :name

  attr_accessor :slug

  validates :name, presence: true

  def id
    @slug
  end

  def persisted?
    id.present?
  end

  def save
    if self.valid?
      proto_project = ProjectsApi
        .new
        .create_project(self)
        .project

      Plan.from_proto(proto_project)
    else
      false
    end
  end

  def update(params)
    if self.valid?
      proto_project = ProjectsApi
      .new
      .rename_project(id: @slug, new_name: params[:name])
      .project

      updated_plan = Plan.from_proto(proto_project)

      @slug = updated_plan.slug
      updated_plan
    else
      false
    end
  end

  def archive
    ProjectsApi
      .new
      .archive_project(self)
  end

  def restore
    ProjectsApi
      .new
      .restore_project(self)
  end

  def destroy
    ProjectsApi
      .new
      .delete_project(self)
  end

  def models
    ProjectsApi
      .new
      .list_models(self)
      .models
      .map { |proto_model| Model.from_proto(proto_model) }
  end

  def find_model(model_id)
    response = ProjectsApi
    .new
    .get_model(self, model_id)

    model = Model.from_proto(response.model)
    model.attributes = response.attributes.map { |proto_attribute| ModelAttribute.from_proto(proto_attribute) }
    model.associations = response.associations.map { |proto_association| ModelAssociation.from_proto(proto_association) }
    model
  end

  class << self
    def from_proto(proto_project)
      Plan.new(
        description: proto_project.description,
        name: proto_project.name,
        slug: proto_project.slug
      )
    end

    def all
      ProjectsApi
        .new
        .list_projects
        .projects
        .map { |proto_project| Plan.from_proto(proto_project) }
    end

    def archived
      ProjectsApi
      .new
      .list_archived_projects
      .projects
      .map { |proto_project| Plan.from_proto(proto_project) }
    end

    def find(id)
      proto_project =
        ProjectsApi
        .new
        .get_project(id)
        .project

      Plan.from_proto(proto_project)
    end
  end
end
