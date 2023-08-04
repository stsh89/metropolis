class NewProjectPage
  attr_reader :project

  def initialize
    @project = Project.new
  end
end
