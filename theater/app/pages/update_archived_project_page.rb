class UpdateArchivedProjectPage
  attr_reader :project

  def initialize(project_id, params)
    @project_id = project_id
    @params = params
    @project = nil
  end

  def update_project
    @project =
      if @params[:recover]
        ProjectsDataProvider.new.recover_project(@project_id)
      end

    @project
  end
end
