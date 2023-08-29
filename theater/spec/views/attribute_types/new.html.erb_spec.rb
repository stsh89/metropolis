require 'rails_helper'

RSpec.describe "attribute_types/new", type: :view do
  before(:each) do
    assign(:attribute_type, AttributeType.new(
      name: "MyString",
      description: "MyText"
    ))
  end

  it "renders new attribute_type form" do
    render

    assert_select "form[action=?][method=?]", attribute_types_path, "post" do

      assert_select "input[name=?]", "attribute_type[name]"

      assert_select "textarea[name=?]", "attribute_type[description]"
    end
  end
end
