# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'The register new user page' do
  before(:each) do
    visit register_path
  end

  describe 'As a user when I visit this page' do
    it 'I see a Register New User header' do
      expect(page).to have_content('Register a New User')
    end

    it 'I see a form to register a new user' do
      expect(page.has_field?).to eq(true)

      expect(page).to have_content('Name:')
      expect(page).to have_content('Email:')
    end

    it 'when I click the register button I am redirected to the dashboard page' do
      fill_in 'Email:', with: 'kit.kat@guhmail.com'
      fill_in 'Name:', with: 'Kat'  

      fill_in 'Password:', with: 'test'
      fill_in 'Confirmation:', with: 'test'

      click_button 'Create User'
      
      expect(current_path).to eq(user_path(User.find_by(user_name: 'Kat')))
    end

    it 'when I click the register button I am redirected register page if that email has been taken' do
      @kat = User.create!(user_name: 'Kat', email: 'kit.kat@guhmail.com', password: 'test')

      fill_in 'Email:', with: 'kit.kat@guhmail.com'
      fill_in 'Name:', with: 'Kat'  

      fill_in 'Password:', with: 'test'
      fill_in 'Confirmation:', with: 'test'

      click_button 'Create User'

      expect(current_path).to eq(register_path)
      expect(page).to have_content('Email has already been taken')
    end

    it 'when I click the register but I enter the wrong confirmation password, I can not submit' do
      fill_in 'Email:', with: 'kit.kat@guhmail.com'
      fill_in 'Name:', with: 'Kat'  

      fill_in 'Password:', with: 'test'
      fill_in 'Confirmation:', with: 'pizzabegood'

      click_button 'Create User'
      
      expect(current_path).to eq(register_path)
      expect(page).to have_content("The passwords must match.")
    end
  end
end
