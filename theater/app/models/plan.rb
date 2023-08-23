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
