module ProjectsHelper
  # rubocop:todo Metrics/MethodLength
  def projects_simple_card_values(projects)
    projects.map do |project|
      {
        name: project.name,
        show_path: project_path(project),
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:todo Metrics/MethodLength
  def projects_breadcrumbs(page_code:, project: nil)
    case page_code
    when :index
      [
        { name: "Entrypoint", path: root_path },
      ]
    when :new, :show
      [
        { name: "Entrypoint", path: root_path },
        { name: "Projects", path: projects_path },
      ]
    when :edit
      [
        { name: "Entrypoint", path: root_path },
        { name: "Projects", path: projects_path },
        { name: project.name, path: project_path(project) },
      ]
    else
      []
    end
  end
  # rubocop:enable Metrics/MethodLength
end
