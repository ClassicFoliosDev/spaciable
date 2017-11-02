# frozen_string_literal: true

class Resident < ApplicationRecord
  include TitleEnum

  acts_as_paranoid

  attr_accessor :subscribe_emails
  attr_reader :raw_invitation_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable,
         :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  has_many :resident_notifications
  has_many :notifications, through: :resident_notifications
  has_many :private_documents, dependent: :destroy

  has_one :plot_residency, dependent: :destroy
  delegate :plot, to: :plot_residency, allow_nil: true
  delegate :developer, :division, :development, :phase, to: :plot, allow_nil: true
  delegate :number, to: :plot
  delegate :prefix, to: :plot

  validates :first_name, :last_name, presence: true
  validates :phone_number, phone: true, allow_nil: true

  def subscribed_status
    if hoozzi_email_updates.to_i.positive? || developer_email_updates.to_i.positive?
      return Rails.configuration.mailchimp[:subscribed]
    end

    Rails.configuration.mailchimp[:unsubscribed]
  end

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
      build_plot_residency(plot_id: plot_record&.id)
    else
      residency = PlotResidency.find_or_initialize_by(resident_id: id)
      residency.plot_id = plot_record&.id
      residency.save
    end
  end

  def full_plot_number
    plot&.to_s
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
