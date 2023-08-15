class DeleteArchivedProjectPage
  def initialize(project_slug)
    @project_slug = project_slug
  end

  def delete_project
    ProjectsDataProvider.new.delete_project(@project_slug)

    @project_slug
  end
end
