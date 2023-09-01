module ModelsHelper
  # rubocop:todo Metrics/MethodLength
  def models_simple_card_values(project, models)
    models.map do |model|
      {
        name: model.name,
        show_path: project_model_path(project, model),
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:todo Metrics/MethodLength
  def model_associations_simple_delete_card_values(project, model, associations)
    associations.map do |association|
      {
        name: association.name,
        delete_path: project_model_association_path(project, model, association),
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:todo Metrics/MethodLength
  def model_attributes_simple_delete_card_values(project, model, attributes)
    attributes.map do |attribute|
      {
        name: attribute.name,
        delete_path: project_model_attribute_path(project, model, attribute),
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:todo Metrics/MethodLength
  def models_breadcrumbs(page_code:, project:, model: nil)
    case page_code
    when :new, :show, :index
      [
        { name: "Entrypoint", path: root_path },
        { name: "Projects", path: projects_path },
        { name: project.name, path: project_path(project) },
      ]
    when :edit
      [
        { name: "Entrypoint", path: root_path },
        { name: "Projects", path: projects_path },
        { name: project.name, path: project_path(project) },
        { name: model.name, path: project_model_path(project, model) },
      ]
    else
      []
    end
  end
  # rubocop:enable Metrics/MethodLength
end
