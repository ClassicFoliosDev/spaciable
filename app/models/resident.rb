# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength, Rails/HasManyOrHasOneDependent
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

  has_many :plot_residencies, dependent: :destroy
  has_many :plots, through: :plot_residencies
  delegate :enable_services?, to: :developer

  validates :first_name, :last_name, presence: true
  validates :phone_number, phone: true
  validates :phone_number, presence: true, on: :create

  validates :email,
            format: { with: Devise.email_regexp },
            uniqueness: { case_sensitive: false },
            length: { minimum: 4, maximum: 254 }

  has_one :lettings_account, as: :accountable, dependent: :destroy

  delegate :authorise, to: :lettings_account

  def subscribed_status
    if cf_email_updates.to_i.positive? || developer_email_updates.to_i.positive? ||
       telephone_updates.to_i.positive?
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

  def referrals_count
    Referral.where(referrer_email: email).count
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

  def plot_residency_role?(plot, roles)
    residency = PlotResidency.find_by(resident_id: id, plot_id: plot.id)
    roles.include?(residency&.role&.to_sym)
  end

  def plot_residency_role_name(plot)
    residency = PlotResidency.find_by(resident_id: id, plot_id: plot.id)
    I18n.t("activerecord.attributes.plot_residency.roles.#{residency.role}")
  end

  def plot_residency_role(plot)
    PlotResidency.find_by(resident_id: id, plot_id: plot.id)&.role
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

  def plot_residency_invited_date(plot)
    residency = PlotResidency.find_by(resident_id: id, plot_id: plot.id)

    residency.created_at
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    if full_name.strip.present?
      full_name
    else
      email
    end
  end

  # Are any of this resident's plots listed as homeowner listings?
  def listings?
    Listing.homeowner_listings(plots).count.positive?
  end

  # does the resident have a lettings account
  def account?
    lettings_account.present?
  end

  # All resident plots with homeowner listings
  def homeowner_listing_plots
    plots.order(number: :asc)
         .select { |p| p.listing? && p.listing.homeowner? }
  end

  # All plots with homeowner listings owned by other residents
  def plots_listing_by_others
    homeowner_listing_plots.select { |p| p.listing.live? && !p.listing.belongs_to?(self) }
  end

  def activation_status
    if invitation_accepted?
      Rails.configuration.mailchimp[:activated]
    else
      Rails.configuration.mailchimp[:unactivated]
    end
  end

  # All resources that can be added to a calendar event
  # require an emails function
  def emails
    [email]
  end

  # rubocop:disable LineLength
  def cala?(post_emd)
    residencies = PlotResidency.resident_on(self, :cala)
    return residencies.count.positive? unless post_emd

    residencies.select { |pr| pr.plot.completion_date? && Time.zone.today >= pr.plot.completion_date }
               .count.positive?
  end
  # rubocop:enable LineLength

  def payment_received(payment_link, payment_for)
    case payment_for
    when Payment::EXTEND_ACCESS
      self.extended_until = Time.zone.today + 1.year
      save
      StripeAction.deactivate_payment_link(payment_link)
      ExtendResidentJob.perform_later(self)
    end
  end

  def create_extension_payment_link
    StripeAction.create_payment_link(self, Payment::EXTEND_ACCESS)
  end

  # resident is marked as extended when they have an
  # extended_until date in the future
  def extended?
    return false unless extended_until

    extended_until > Time.zone.today
  end

  # Scheduled expiry emails.  Run inside an exclusive Lock to ensure
  # this runs on only one web server
  def self.notify_expiry
    Lock.run :notify_expiry_residents do
      expiry_residents = []
      Resident.find_each do |resident|
        expiry_residents << resident.id if resident.extended_until == Time.zone.today - 1.day
      end

      ExpiryResidentsJob.perform_later(expiry_residents)
    end
  end

  def reset_token
    set_reset_password_token
  end

  # rubocop:disable Naming/PredicateName
  def has_living_plot?
    plot_residencies.each { |pr| return true unless pr.platform?(:native) }

    false
  end
  # rubocop:enable Naming/PredicateName
end
# rubocop:enable Metrics/ClassLength, Rails/HasManyOrHasOneDependent
