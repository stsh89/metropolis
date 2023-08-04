class CreateProjectPage
  def initialize(params)
    @params = params
  end

  def create_project
    ProjectsDataProvider.new.setup_project_environment(@params)
  end
end
