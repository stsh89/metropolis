class Project
  attr_accessor :id

  attr_accessor :name

  attr_accessor :description

  attr_accessor :create_time

  def initialize(**attributes)
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end
end
