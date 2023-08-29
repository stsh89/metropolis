require 'rails_helper'

RSpec.describe "attribute_types/show", type: :view do
  before(:each) do
    assign(:attribute_type, AttributeType.create!(
      name: "Name",
      description: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
