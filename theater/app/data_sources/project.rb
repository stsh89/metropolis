class Project
  include ActiveModel::API

  attr_accessor :id

  attr_accessor :name

  attr_accessor :description

  attr_accessor :create_time

  def nice_create_time
    @create_time.strftime('%Y-%m-%d %H:%M:%S')
  end

  class << self
    def from_proto(proto_project)
      Project.new(
        id: proto_project.id,
        name: proto_project.name,
        description: proto_project.description,
        create_time: proto_project.create_time.to_time
      )
    end
  end
end
