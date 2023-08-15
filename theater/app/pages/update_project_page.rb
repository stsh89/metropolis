class UpdateProjectPage
  def initialize(project_slug, params)
    @project_slug = project_slug
    @params = params
  end

  def update_project
    puts @params
    puts @project_slug
    puts "xxxxxxxxxxxxxx"

    if @params[:archive]
      ProjectsDataProvider.new.archive_project(@project_slug)
    end

    true
  end
end
