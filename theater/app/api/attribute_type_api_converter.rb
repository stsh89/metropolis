# Map attribute type model values to API definition and vise versa.
class AttributeTypeApiConverter
  class << self
    # Convert attribute type model to API definition
    #
    # @param attribute_type [AttributeType]
    # @return [Proto::Temple::V1::AttributeType]
    def from_model(attribute_type)
      Proto::Temple::V1::AttributeType.new(
        description: attribute_type.description,
        name: attribute_type.name,
        slug: attribute_type.slug,
      )
    end

    # Convert attribute type's API definition to model.
    #
    # @param proto_attribute_type [Proto::Temple::V1::AttributeType]
    # @return [AttributeType]
    def to_model(proto_attribute_type)
      AttributeType.new(
        description: proto_attribute_type.description,
        name: proto_attribute_type.name,
        slug: proto_attribute_type.slug,
      )
    end
  end
end
