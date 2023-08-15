class CreateProjectPage
  attr_reader :project
  def initialize(params)
    @params = params
  end

  def create_project
    @project = ProjectsDataProvider.new.create_project(@params)
  end
end
