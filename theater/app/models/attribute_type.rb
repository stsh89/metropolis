class AttributeType
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :description, :name, :slug

  validates :name, presence: true

  def id
    @slug
  end

  def persisted?
    id.present?
  end

  def save
    return if invalid?

    proto_attribute_type = AttributeTypesApi.instance.create_attribute_type(self)
    @slug = proto_attribute_type.slug
    AttributeType.from_proto(proto_attribute_type)
  end

  def update(params)
    assign_attributes(params)

    return if invalid?

    proto_attribute_type = AttributeTypesApi.instance.update_attribute_type(self)
    @slug = proto_attribute_type.slug
    AttributeType.from_proto(proto_attribute_type)
  end

  def destroy
    AttributeTypesApi
      .instance
      .delete_attribute_type(self)
  end

  # Tests only method
  def reload
    attribute_type = AttributeType.find(id)
    @slug = attribute_type.slug
    @name = attribute_type.name
    @description = attribute_type.description

    self
  end

  class << self
    def from_proto(proto_attribute_type)
      AttributeType.new(
        description: proto_attribute_type.description,
        name: proto_attribute_type.name,
        slug: proto_attribute_type.slug,
      )
    end

    def all
      AttributeTypesApi
        .instance
        .list_attribute_types
        .attribute_types
        .map { |proto_attribute_type| AttributeType.from_proto(proto_attribute_type) }
    end

    def find(id)
      proto_attribute_type =
        AttributeTypesApi
          .instance
          .get_attribute_type(id)

      AttributeType.from_proto(proto_attribute_type)
    end

    # Tests only method
    def count
      all.size
    end

    # Tests only method
    def last
      all.last
    end

    # Tests only method
    def create!(attributes)
      attribute_type = AttributeType.new(attributes).save

      unless attribute_type
        raise StandardError, "can't create attribute type with invalid attributes"
      end

      attribute_type
    end
  end
end
