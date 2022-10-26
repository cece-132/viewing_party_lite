require 'rails_helper'

RSpec.describe "User Login" do
  describe 'User Login' do
    it 'registered user can login' do
      @user = create(:user)
      visit root_path

      click_button "Login"

      expect(current_path).to eq("/login")

      email = @user.email
      password = @user.password

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log In"

      expect(current_path).to eq user_path
      expect(page).to have_content("Welcome Back #{@user.user_name}! Couldn't stay away for long we see")
    end

    it "cannot log in with bad credentials" do
      user = create(:user)
    
      # we don't have to go through root_path and click the "I have an account" link any more
      visit login_path
    
      fill_in :email, with: user.email
      fill_in :password, with: "incorrect password"
      click_on "Log In"
    
      expect(current_path).to eq(login_path)
    
      expect(page).to have_content("Uhmm...this is awkward...but you're wrong")
    end 

  end
end