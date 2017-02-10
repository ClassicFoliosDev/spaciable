# frozen_string_literal: true
class Resident < ApplicationRecord
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :plot_residents
  has_many :plots, through: :plot_residents

  has_many :resident_notifications
  has_many :notifications, through: :resident_notifications

  def brand
    # TODO: use permissions to determine the first brand in the
    # permission hierarchy to use.
  end

  def to_s
    full_name = "#{first_name} #{last_name}"

    if full_name.strip.present?
      full_name
    else
      email
    end
  end
end
