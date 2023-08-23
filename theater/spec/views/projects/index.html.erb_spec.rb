require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  before(:each) do
    assign(:projects, [
      Project.new(
        name: "Book store",
        description: "Buy and sell books platform."
      ),
      Project.new(
        name: "Book store",
        description: "Buy and sell books platform."
      )
    ])
  end

  it "renders a list of projects" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Book store".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Buy and sell books platform.".to_s), count: 2
  end
end
