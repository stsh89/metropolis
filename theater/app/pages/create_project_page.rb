class CreateProjectPage
  def initialize(params)
    @params = params
  end

  def create_project
    ProjectsDataProvider.new.initialize_project(@params)
  end
end
