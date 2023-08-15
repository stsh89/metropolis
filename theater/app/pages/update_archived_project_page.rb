class UpdateArchivedProjectPage
  attr_reader :project

  def initialize(project_slug, params)
    @project_slug = project_slug
    @params = params
  end

  def update_project
    if @params[:restore]
      ProjectsDataProvider.new.restore_project(@project_slug)
    end

    true
  end
end
