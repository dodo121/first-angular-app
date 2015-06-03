require 'spec_helper'

feature 'find by letter', js: true do
  before do
    Recipe.create(name: "Awesome Avocado")
    Recipe.create(name: "Beer Soup")
  end

  scenario "search by clicking a letter" do
    visit "/"
    page.find('.letters li span', text: "A").click
    expect(page).to have_content("Search results")
    expect(page).to have_content("Awesome Avocado")
    expect(page).to_not have_content("List of all recipes")
    expect(page).to_not have_content("Beer Soup")

    page.find('.letters li', text: "#").click
    expect(page).to have_content("List of all recipes")
    expect(page).to_not have_content("Search results")
    expect(page).to have_content("Awesome Avocado")
    expect(page).to have_content("Beer Soup")
  end
end
