require 'rails_helper'

RSpec.describe "plans/edit", type: :view do
  let(:plan) {
    Plan.create!(
      name: "MyString",
      description: "MyText"
    )
  }

  before(:each) do
    assign(:plan, plan)
  end

  it "renders the edit plan form" do
    render

    assert_select "form[action=?][method=?]", plan_path(plan), "post" do

      assert_select "input[name=?]", "plan[name]"

      assert_select "textarea[name=?]", "plan[description]"
    end
  end
end
