# frozen_string_literal: true
class Resident < ApplicationRecord
  include TitleEnum

  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :resident_notifications
  has_many :notifications, through: :resident_notifications

  has_one :plot_residency, dependent: :destroy
  delegate :plot, to: :plot_residency, allow_nil: true
  delegate :developer, :division, :development, :phase, to: :plot, allow_nil: true

  def create_without_password(**params)
    extend User::NoPasswordRequired

    params.delete(:password)
    params.delete(:password_confirmation)
    self.password = nil
    self.password_confirmation = nil

    assign_attributes(params)
    save
  end

  def plot=(plot_record)
    if new_record?
      build_plot_residency(plot_id: plot_record.id)
    else
      residency = PlotResidency.find_or_initialize_by(resident_id: id)
      residency.plot_id = plot_record.id
      residency.save
    end
  end

  def brand
    phase&.brand || development&.brand || division&.brand || developer&.brand || Brand.new
  end

  def plot_number
    plot&.number&.to_s
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
