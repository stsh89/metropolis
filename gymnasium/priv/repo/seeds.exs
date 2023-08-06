# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Gymnasium.Repo.insert!(%Gymnasium.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

projects_data = [
  %{
    description: "An online platform for buying and selling books.",
    name: "Bookstore",
    slug: "bookstore"
  }
]

Enum.each(projects_data, fn data ->
  Gymnasium.Dimensions.create_project(data)
end)
