# frozen_string_literal: true
require 'bcrypt'

class User < ApplicationRecord
  include BCrypt
  
  validates_presence_of :user_name, :email, :password_digest
  validates :email, uniqueness: true
  validates :user_name, uniqueness: true

  has_many :viewing_party_users
  has_many :viewing_parties, through: :viewing_party_users

  has_secure_password

  def find_invited_parties
    viewing_parties.where.not('host = ?', user_name)
  end

  def find_hosted_parties
    viewing_parties.where('host = ?', user_name)
  end

end
