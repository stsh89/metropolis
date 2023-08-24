class Project
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

      project = Project.from_proto(proto_project)

      @slug = project.slug

      project
    else
      false
    end
  end

  def rename(new_name)
    @name = new_name

    if self.valid?
      proto_project = ProjectsApi
      .new
      .rename_project(self)
      .project

      updated_project = Project.from_proto(proto_project)

      @slug = updated_project.slug
      updated_project
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
      Project.new(
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
        .map { |proto_project| Project.from_proto(proto_project) }
    end

    def archived
      ProjectsApi
      .new
      .list_archived_projects
      .projects
      .map { |proto_project| Project.from_proto(proto_project) }
    end

    def find(id)
      proto_project =
        ProjectsApi
        .new
        .get_project(id)
        .project

      Project.from_proto(proto_project)
    end
  end
end
