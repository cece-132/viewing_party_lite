# frozen_string_literal: true

class ViewingParty < ApplicationRecord
  validates_presence_of :host, :duration, :movie_id, :image_path, :movie_title, :start_time
  validates_numericality_of :duration
  validates_numericality_of :movie_id

  has_many :viewing_party_users
  has_many :users, through: :viewing_party_users

  def invited_users
    users.where.not('user_name = ?', host)
  end

end
