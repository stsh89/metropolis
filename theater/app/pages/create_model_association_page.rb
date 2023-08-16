class CreateModelAssociationPage
  def initialize(params)
    @params = params
  end

  def create_model_association
    ModelAssociationDataProvider.new.create_model_association(@params)
  end
end
