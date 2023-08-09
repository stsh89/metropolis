class UpdateProjectPage
  def initialize(project_id, params)
    @project_id = project_id
    @params = params
    @project = nil
  end

  def update_project
    @project =
      if @params[:archive]
        ProjectsDataProvider.new.archive_project(@project_id)
      end

    @project
  end
end
