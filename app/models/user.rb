# frozen_string_literal: true

class User < ApplicationRecord
  validates_presence_of :user_name, :email, :password
  validates :email, uniqueness: true

  has_secure_password
  
  has_many :viewing_party_users
  has_many :viewing_parties, through: :viewing_party_users

  def find_invited_parties
    viewing_parties.where.not('host = ?', user_name)
  end

  def find_hosted_parties
    viewing_parties.where('host = ?', user_name)
  end
end
