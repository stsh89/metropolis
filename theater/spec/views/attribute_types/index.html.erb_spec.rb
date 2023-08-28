require 'rails_helper'

RSpec.describe "attribute_types/index", type: :view do
  before(:each) do
    assign(:attribute_types, [
      AttributeType.create!(
        name: "Bigint",
        description: "Long-ranged integer."
      ),
      AttributeType.create!(
        name: "Float",
        description: "Inexact, variable-precision numeric type."
      )
    ])
  end

  it "renders a list of attribute_types" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Bigint".to_s), count: 1
    assert_select cell_selector, text: Regexp.new("Float".to_s), count: 1
  end
end
