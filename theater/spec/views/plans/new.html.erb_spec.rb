require 'rails_helper'

RSpec.describe "plans/new", type: :view do
  before(:each) do
    assign(:plan, Plan.new(
      name: "MyString",
      description: "MyText"
    ))
  end

  it "renders new plan form" do
    render

    assert_select "form[action=?][method=?]", plans_path, "post" do

      assert_select "input[name=?]", "plan[name]"

      assert_select "textarea[name=?]", "plan[description]"
    end
  end
end
