class Project
  attr_accessor :name

  attr_accessor :description

  attr_accessor :create_timestamp

  def initialize(**attributes)
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end
end
