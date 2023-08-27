require 'rails_helper'

RSpec.describe "attribute_types/index", type: :view do
  before(:each) do
    assign(:attribute_types, [
      AttributeType.create!(
        name: "Name",
        description: "MyText"
      ),
      AttributeType.create!(
        name: "Name",
        description: "MyText"
      )
    ])
  end

  it "renders a list of attribute_types" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
