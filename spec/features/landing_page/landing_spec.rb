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

        visit root_path

        within("#existing-users") do
          expect(page).to have_content("#{@user.email}")
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
          # click_link "#{@user.email}"
        end
      end
    end

    describe 'registered users' do
      it 'should not show the Login or create and Account Button/link' do
        @user = create(:user)
        visit root_path

        expect(page).to have_button("Create New User")
        expect(page).to have_button("Login")

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit root_path

        expect(page).to have_button("Logout")
        expect(page).to_not have_button("Login")
        expect(page).to_not have_button("Create New User")
      end

      it 'should be able to logout' do
        @user = create(:user)
        
        visit '/login'

        email = @user.email
        password = @user.password
  
        fill_in :email, with: email
        fill_in :password, with: password   
        click_button "Log In"

        visit root_path

        click_button 'Logout'

        expect(current_path).to eq "/logout"
        expect(page).to have_content("You are now logged out")

        click_on "Home"

        expect(page).to have_button("Create New User")
        expect(page).to have_button("Login")
      end
    end

    describe 'authorization' do
      describe 'as a visitor' do
        describe 'when I try to vist /user' do
          it 'I see a message that tells me to log in' do
            visit '/user'

            expect(page).to have_content("Please login")
            expect(current_path).to eq "/"
          end
        end
        describe 'when I try to visit /movies/550' do
          it 'I see a message that tells me to log in' do
            visit '/movies/550'

            expect(page).to have_content("Please login")
            expect(current_path).to eq "/"
          end
        end
      end
    end
  end
end
