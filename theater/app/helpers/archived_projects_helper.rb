module ArchivedProjectsHelper
  # rubocop:todo Metrics/MethodLength
  def archived_projects_simple_card_values(projects)
    projects.map do |project|
      {
        name: project.name,
        show_path: archived_project_path(project),
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:todo Metrics/MethodLength
  def archived_projects_breadcrumbs(page_code:)
    case page_code
    when :index
      [
        { name: "Entrypoint", path: root_path },
      ]
    when :show
      [
        { name: "Entrypoint", path: root_path },
        { name: "Archive", path: archived_projects_path },
      ]
    else
      []
    end
  end
  # rubocop:enable Metrics/MethodLength
end
