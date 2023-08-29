require 'rails_helper'

RSpec.describe "attribute_types/edit", type: :view do
  let(:attribute_type) {
    AttributeType.create!(
      name: "MyString",
      description: "MyText"
    )
  }

  before(:each) do
    assign(:attribute_type, attribute_type)
  end

  it "renders the edit attribute_type form" do
    render

    assert_select "form[action=?][method=?]", attribute_type_path(attribute_type), "post" do

      assert_select "input[name=?]", "attribute_type[name]"

      assert_select "textarea[name=?]", "attribute_type[description]"
    end
  end
end
