# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Landing Page" do
  describe "As a user when I visit the Landing Page" do
    it 'I see the header for the page' do
      visit root_path
        
      expect(page).to have_content("Viewing Party Light")
    end

    describe 'Navigation Bar' do
      it 'should have a navigation bar' do
        visit root_path

        expect(page).to have_css('.topnav', text: 'Home', visible: true)
        expect(page).to have_css('.topnav', text: 'About', visible: true)
        expect(page).to have_css('.topnav', text: 'Viewing Party Light', visible: true)
      end

      it 'home button should navigate to landing page' do
        visit root_path

        # save_and_open_page
        click_link 'Home'
        expect(current_path).to eq root_path
      end

      it 'about button should navigate to about page' do
        visit root_path

        click_link 'About'

        expect(current_path).to eq about_path
      end
    end

    describe 'Create New User button' do
      it 'should have a button to create a new user' do
        visit root_path

        expect(page).to have_button("Create New User")
      end

      it 'should link to the user#new page' do
        visit root_path

        click_button "Create New User"

        expect(current_path).to eq('/register')
      end
    end

    describe 'existing users' do
      it 'should have a section for existing users' do
        visit root_path

        within("#existing-users") do
          expect(page).to have_content("Existing Users")
        end
      end

      it 'should show the user email' do
        @user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

        visit root_path

        within("#existing-users") do
          expect(page).to have_link("#{@user.email}")
          click_link "#{@user.email}"
        end

        expect(current_path).to eq user_path
      end
    end
  end
end
