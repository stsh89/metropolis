class Project
  include ActiveModel::API

  attr_accessor :id

  attr_accessor :name

  attr_accessor :description

  attr_accessor :create_time

  attr_accessor :slug
end
