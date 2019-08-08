# frozen_string_literal: true

class Resident < ApplicationRecord
  include TitleEnum

  attr_accessor :subscribe_emails, :subscribe_sms, :invitation_plot,
                :accept_ts_and_cs, :role, :admin_preview
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
  has_many :resident_services, dependent: :delete_all
  has_many :services, through: :resident_services

  has_many :plot_residencies, dependent: :destroy
  has_many :plots, through: :plot_residencies
  delegate :enable_services?, to: :developer

  validates :first_name, :last_name, presence: true
  validates :phone_number, phone: true
  validates :phone_number, presence: true, on: :create

  def subscribed_status
    if cf_email_updates.to_i.positive? || developer_email_updates.to_i.positive? ||
       developer_sms_updates.to_i.positive?
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

  def services_enabled?
    plots.any?(&:enable_services?)
  end

  def plot=(plot_record)
    if new_record?
      PlotResidency.new(resident_id: id, plot_id: plot_record&.id)
    else
      residency = PlotResidency.find_or_initialize_by(resident_id: id)
      residency.plot_id = plot_record&.id
      residency.save
    end
  end

  def plot_residency_role_name(plot)
    residency = PlotResidency.find_by(resident_id: id, plot_id: plot.id)
    I18n.t("activerecord.attributes.plot_residency.roles.#{residency.role}")
  end

  def plot_residency_homeowner?(plot)
    residency = PlotResidency.find_by(resident_id: id, plot_id: plot.id)
    return false if residency.blank?

    # If residency role is blank, this is a legacy resident,
    # so it predates the tenant function and must be a homeowner
    return true if residency.role.blank?

    residency.role == "homeowner"
  end

  def plot_residency_primary_resident?(plot)
    residency = PlotResidency.find_by(resident_id: id, plot_id: plot.id)
    return false if residency.blank?

    # If residency invited by is blank, this is a legacy resident,
    # so it predates the tenant function and must be a homeowner
    return true if residency.invited_by.blank?

    residency.invited_by.class == User
  end

  def plot_residency_tenant?(plot)
    residency = PlotResidency.find_by(resident_id: id, plot_id: plot.id)

    residency.role == "tenant"
  end

  def plot_residency_invited_by(plot)
    residency = PlotResidency.find_by(resident_id: id, plot_id: plot.id)

    residency.invited_by
  end

  def to_s
    full_name = "#{first_name} #{last_name}"

    if full_name.strip.present?
      full_name
    else
      email
    end
  end

  def letable_plots?(plots)
    letable = false
    plots.each do |plot|
      return letable = true if plot.letable
    end
    letable
  end
end
