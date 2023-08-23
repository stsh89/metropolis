require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  before(:each) do
    assign(:project, Project.new(
      name: "Book store",
      description: "Buy and sell books platform.",
      slug: "book-store"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Book store/)
    expect(rendered).to match(/Buy and sell books platform./)
  end
end
