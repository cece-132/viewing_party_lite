# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :user_name }
    it { should validate_uniqueness_of :user_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password_digest }
    it { should validate_uniqueness_of :email }
    it { should have_secure_password }
   
    it 'shouldnt have user attribute password' do
      user = User.create(user_name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')
      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq('password123')
    end 

  end

  describe 'relationships' do
    it { should have_many :viewing_party_users }
    it { should have_many(:viewing_parties).through(:viewing_party_users) }
  end

  describe 'instance methods' do
    describe '#find_invited_parties' do
      before :each do
        Faker::UniqueGenerator.clear
        @user = create(:user)
        @awesome_host = create(:user)
        @other_user = create(:user)
        # create 4 viewing parties each hosted by awesome_host
        @viewing_party_invites = create_list(:viewing_party, 4, host: @awesome_host.user_name)
        # creates 5 viewing_party_users, three rando invites, one for the user and one for the host for each viewing party
        @viewing_party_invites.each do |viewing_party|
          create_list(:viewing_party_user, 3, viewing_party: viewing_party)
          create(:viewing_party_user, viewing_party: viewing_party, user: @user)
          create(:viewing_party_user, viewing_party: viewing_party, user: @awesome_host)
        end
        # create 4 viewing parties each hosted by user
        @viewing_party_hosting = create_list(:viewing_party, 4, host: @user.user_name)
        # creates 4 viewing_party_users, three rando invites, one for the user for each viewing party
        @viewing_party_hosting.each do |viewing_party|
          create_list(:viewing_party_user, 3, viewing_party: viewing_party)
          create(:viewing_party_user, viewing_party: viewing_party, user: @user)
        end
        # creates viewing party not associated with the user with three rando invites
        @other_viewing_party = create(:viewing_party, host: @other_user.user_name)
        create_list(:viewing_party_user, 3, viewing_party: @other_viewing_party)
        # creates viewing party where only the user is invited
        @lonely_viewing_party = create(:viewing_party, host: @user.user_name)
        create(:viewing_party_user, viewing_party: @lonely_viewing_party, user: @user)
      end

      it 'lists viewing parties that user has been invited to' do
        expect(@user.find_invited_parties).to eq(@viewing_party_invites)
      end

      context 'if there are no viewing parties user has been invited to' do
        it 'returns an empty array' do
          expect(@other_user.find_invited_parties).to eq([])
        end
      end
    end

    describe '#find_hosted_parties' do
      before :each do
        Faker::UniqueGenerator.clear
        @user = create(:user)
        @awesome_host = create(:user)
        @other_user = create(:user)
        # create 4 viewing parties each hosted by awesome_host
        @viewing_party_invites = create_list(:viewing_party, 4, host: @awesome_host.user_name)
        # creates 5 viewing_party_users, three rando invites, one for the user and one for the host for each viewing party
        @viewing_party_invites.each do |viewing_party|
          create_list(:viewing_party_user, 3, viewing_party: viewing_party)
          create(:viewing_party_user, viewing_party: viewing_party, user: @user)
          create(:viewing_party_user, viewing_party: viewing_party, user: @awesome_host)
        end
        # create 4 viewing parties each hosted by user
        @viewing_party_hosting = create_list(:viewing_party, 4, host: @user.user_name)
        # creates 4 viewing_party_users, three rando invites, one for the user for each viewing party
        @viewing_party_hosting.each do |viewing_party|
          create_list(:viewing_party_user, 3, viewing_party: viewing_party)
          create(:viewing_party_user, viewing_party: viewing_party, user: @user)
        end
        # creates viewing party not associated with the user with three rando invites
        @other_viewing_party = create(:viewing_party, host: @other_user.user_name)
        create_list(:viewing_party_user, 3, viewing_party: @other_viewing_party)
        # creates viewing party where only the user is invited
        @lonely_viewing_party = create(:viewing_party, host: @user.user_name)
        create(:viewing_party_user, viewing_party: @lonely_viewing_party, user: @user)
      end

      it 'lists viewing parties that user is hosting' do
        all_hosted_parties = @viewing_party_hosting << @lonely_viewing_party

        expect(@user.find_hosted_parties).to eq(all_hosted_parties)
      end

      context 'if user has no hosted parties' do
        it 'returns an empty array' do
          shmoozer = create(:user)
          @viewing_party_invites.each do |viewing_party|
            create(:viewing_party_user, viewing_party: viewing_party, user: shmoozer)
          end
          expect(shmoozer.find_hosted_parties).to eq([])
        end
      end
    end
  end
end
