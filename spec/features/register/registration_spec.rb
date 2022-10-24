require 'rails_helper'

RSpec.describe "User Registration" do |descr|
  describe 'User Registration Form' do
    it 'creates a new user' do
      visit root_path

      click_button "Create New User"

      expect(current_path).to eq "/register"

      username = "LaLa"
      email = "ladeeda@aol.com"
      password = "PasswoRd"

      fill_in :user_user_name, with: username
      fill_in :user_email, with: email
      fill_in :user_password, with: password
      fill_in :user_password_confirmation, with: password

      click_button "Create User"
      new_user = User.last

      expect(current_path).to eq user_path(new_user)
      expect(page).to have_content("Welcome, #{new_user.user_name}")
      expect(password).to_not eq new_user.password
    end

    it 'sad path: incorrect/incomplete data returns a flash message' do
      visit root_path

      click_button "Create New User"

      expect(current_path).to eq "/register"

      username = "LaLa"
      email = "ladeeda@aol.com"
      # password = "PasswoRd"

      fill_in :user_user_name, with: username
      fill_in :user_email, with: email
      # fill_in :user_password, with: password
      # fill_in :user_password_confirmation, with: password

      click_button "Create User"

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Password can't be blank")
    end
  end
end