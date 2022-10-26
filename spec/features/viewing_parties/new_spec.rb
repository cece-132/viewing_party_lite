require 'rails_helper'

RSpec.describe 'New Viewing Party' do
  
  before :each do
    VCR.use_cassette('fight_club_movie_data_v1') do
      @user = create(:user)
      @friend1 = create(:user)
      @friend2 = create(:user)
      @friend3 = create(:user)
      @frenemy = create(:user)
      @friends = [@friend1, @friend2, @friend3]
      fight_club = File.read('spec/fixtures/fight_club.json')
      movie_data = JSON.parse(fight_club, symbolize_names: true)
      @movie = Movie.new(movie_data)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit new_movie_viewing_party_path(@movie.id)
    end
  end

  describe 'as a user, when I visit the new viewing party page' do
    it 'has the name of the movie rendered above the form' do
      expect(page).to have_content(@movie.title)
    end

    describe 'form' do
      it 'should have duration field' do
        expect(page).to have_field(:viewing_party_duration, with: @movie.runtime)
      end

      it 'should have date field' do
        expect(page).to have_field(:viewing_party_date)
      end

      it 'should have time field' do
        expect(page).to have_field(:viewing_party_time)
      end

      it 'has field called invited_users with checkboxes for each user in the system' do
        all_other_users = [@friend1, @friend2, @friend3, @frenemy]
        within '#invited_users_list' do
          all_other_users.each do |user|
            expect(page).to have_field("viewing_party_invited_users_#{user.id}")
            expect(page).to have_content(user.user_name)
          end
        end
      end

      it 'should have create button' do
        expect(page).to have_button('Create Viewing party')
      end
    end

    describe 'submitting form' do
      context 'when all field filled out appropriately' do
        it 'returns the user back to their dashboard with new viewing party present' do
          # save_and_open_page
          fill_in :viewing_party_duration, with: 155
          fill_in :viewing_party_date, with: '2022-11-30'
          fill_in :viewing_party_time, with: '15:21'

          @friends.each do |user|
            check "viewing_party_invited_users_#{user.id}"
          end
          click_button 'Create Viewing party'

          expect(current_path).to eq(user_path)
          new_viewing_party = ViewingParty.last
          within "#hosted_parties" do
            expect(page).to have_css("#party_#{new_viewing_party.id}")
            expect(page).to have_link(new_viewing_party.movie_title)
          end
        end

        it 'has the viewing party present on each invited users dashboard' do
          fill_in :viewing_party_duration, with: 155
          fill_in :viewing_party_date, with: '2022-11-30'
          fill_in :viewing_party_time, with: '15:21'

          @friends.each do |user|
            check "viewing_party_invited_users_#{user.id}"
          end
          click_button 'Create Viewing party'
          new_viewing_party = ViewingParty.last
          @friends.each do |user|
            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
            visit user_path
            within "#invited_parties" do
              expect(page).to have_css("#party_#{new_viewing_party.id}")
              expect(page).to have_link(new_viewing_party.movie_title)
            end
          end
        end
      end

      # context 'when the duration is less than the movie runtime' do
      #   it 'keeps the user on the page' do

      #   end
      # end

      # context 'when no users are selected for the viewing party' do
      #   it 'returns the user back to the dashboard with a flash message' do

      #   end
      # end
    end
  end
  VCR.eject_cassette
end