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

      fill_in :user_name, with: username
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password

      click_button "Create New User"
      new_user = User.last

      expect(current_path).to eq user_path(new_user)
    end
  end
end