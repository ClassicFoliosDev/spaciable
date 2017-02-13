# frozen_string_literal: true
class Resident < ApplicationRecord
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :resident_notifications
  has_many :notifications, through: :resident_notifications

  has_one :plot_residency
  delegate :plot, to: :plot_residency, allow_nil: true
  delegate :developer, :division, :development, :phase, to: :plot

  def plot=(plot_record)
    (plot_residency || build_plot_residency).update(plot: plot_record)
  end

  def brand
    phase&.brand || development&.brand || division&.brand || developer&.brand || Brand.new
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
