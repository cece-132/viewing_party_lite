# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe 'Discover Movies Page' do
  describe 'As a user when I visit the discover movies page' do
    it 'has a Discover Movies header' do
      @alex = user = create(:user)

      visit user_discover_path(@alex)

      expect(page).to have_content('Discover Movies')
    end

    it 'should have a button for top rated movies' do
      user = create(:user)

      visit user_discover_path(user)

      expect(page).to have_button("Top Rated Movies")
    end

    it 'current_path should have a section for top rated movies' do
      VCR.use_cassette('top_40_movies') do
        user = create(:user)

        visit user_discover_path(user)
        expect(page).to_not have_css("#top_40_movies")

        click_button "Top Rated Movies"
        expect(page).to have_css("#top_40_movies")
        expect(page).to have_button("Discover Page")
      end
    end

    it 'has a search bar' do
      VCR.use_cassette('search') do
        user = create(:user)

        visit user_discover_path(user)
        expect(page).to have_button('Find Movies')

        page.fill_in with: "fight cLub"
        click_button 'Find Movies'
        expect(current_path).to eq user_discover_path(user)
        expect(page).to have_content "Fight Club"
      end
    end

    it 'has button to navigate back to the discover page' do
      VCR.use_cassette('search') do
        user = create(:user)

        visit user_discover_path(user)
        expect(page).to have_button('Find Movies')

        page.fill_in with: "fight cLub"
        click_button 'Find Movies'

        within("#search_results") do
          expect(page).to have_button "Discover Page"
          click_button "Discover Page"
        end

        expect(current_path).to eq user_discover_path(user)
      end
    end

    it 'should be able to navigate to the discover page' do
      VCR.use_cassette('top_40_discover') do
        user = create(:user)

        visit user_discover_path(user)

        click_button "Top Rated Movies"
        expect(page).to have_button("Discover Page")
        click_button "Discover Page"

        expect(current_path).to eq user_discover_path(user)
      end
    end

    it 'should be able to navigate to the discover page' do
      VCR.use_cassette('user_movies_show_page') do
        user = create(:user)
        visit user_discover_path(user)
        
        click_button "Top Rated Movies"

        click_link "The Godfather"

        expect(current_path).to eq user_movie_path(user, 238)
      end
    end

    it 'it returns a message on the page' do
      VCR.use_cassette('search_no_searches') do
        user = create(:user)

        visit user_discover_path(user)

        page.fill_in with: "supercalir"
        click_button 'Find Movies'

        within("#search_results") do
          expect(page).to have_content("No Movies Found, Please Try Again")
        end
      end
    end
  end
end
