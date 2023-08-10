class DeleteArchivedProjectPage
  def initialize(project_id)
    @project_id = project_id
  end

  def delete_project
    ProjectsDataProvider.new.delete_project(@project_id)

    @project_id
  end
end
