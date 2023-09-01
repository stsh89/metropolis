module AttributeTypesHelper
  # rubocop:todo Metrics/MethodLength
  def attribute_types_simple_card_values(attribute_types)
    attribute_types.map do |attribute_type|
      {
        name: attribute_type.name,
        show_path: attribute_type_path(attribute_type),
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:todo Metrics/MethodLength
  def attribute_types_breadcrumbs(page_code:, attribute_type: nil)
    case page_code
    when :index
      [
        { name: "Entrypoint", path: root_path },
      ]
    when :new, :show
      [
        { name: "Entrypoint", path: root_path },
        { name: "Attribute types", path: attribute_types_path },
      ]
    when :edit
      [
        { name: "Entrypoint", path: root_path },
        { name: "Attribute types", path: attribute_types_path },
        { name: attribute_type.name, path: attribute_type_path(attribute_type) },
      ]
    else
      []
    end
  end
  # rubocop:enable Metrics/MethodLength
end
