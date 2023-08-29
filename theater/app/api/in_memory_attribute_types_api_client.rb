class InMemoryAttributeTypesApiClient
  def initialize
    @attribute_types = []
  end

  # rubocop:todo Metrics/MethodLength
  def create_attribute_type(attribute_type)
    proto_attribute_type = Proto::Temple::V1::AttributeType.new(
      description: attribute_type.description,
      name: attribute_type.name,
      slug: attribute_type.name.downcase,
    )

    @attribute_types.push(proto_attribute_type)
    @attribute_types.sort_by!(&:name)

    proto_attribute_type
  end
  # rubocop:enable Metrics/MethodLength

  def list_attribute_types
    Proto::Temple::V1::ListAttributeTypesResponse.new(
      attribute_types: @attribute_types,
    )
  end

  def get_attribute_type(id)
    @attribute_types.detect { |at| at.slug == id }
  end

  # rubocop:todo Metrics/MethodLength
  def update_attribute_type(attribute_type)
    proto_attribute_type = Proto::Temple::V1::AttributeType.new(
      description: attribute_type.description,
      name: attribute_type.name,
      slug: attribute_type.slug,
    )

    @attribute_types.delete_if { |at| at.slug == attribute_type.slug }
    @attribute_types.push(proto_attribute_type)
    @attribute_types.sort_by!(&:name)

    proto_attribute_type
  end
  # rubocop:enable Metrics/MethodLength

  def delete_attribute_type(attribute_type)
    @attribute_types.delete_if { |at| at.slug == attribute_type.slug }
  end

  def delete_all_attribute_types
    @attribute_types = []
  end
end
