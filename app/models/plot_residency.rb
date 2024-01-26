# frozen_string_literal: true

class PlotResidency < ApplicationRecord
  belongs_to :plot, optional: false
  belongs_to :resident, optional: false, autosave: true
  belongs_to :invited_by, polymorphic: true

  enum role: %i[
    tenant
    homeowner
    prospect
  ]

  validate :email_updated, on: :update
  validates_associated :resident
  validates :resident, uniqueness: { scope: :plot }

  before_validation :set_resident
  before_validation :assign_resident_attributes
  before_validation :allow_resident_to_be_passwordless

  def allow_resident_to_be_passwordless
    resident.extend(User::NoPasswordRequired)
  end

  def email_updated
    return if email == Resident.find(resident.id).email

    errors.add(:email, :change_email)
  end

  delegate :to_s, :title, :first_name, :last_name, :email, :phone_number, :extended?, to: :resident
  delegate :create_extension_payment_link, to: :resident
  delegate :invitation_accepted_at, to: :resident
  delegate :number, to: :plot, prefix: true
  delegate :platform?, to: :plot

  attr_writer :title, :first_name, :last_name, :email, :phone_number

  scope :resident_on,
        lambda { |resident, developer|
          joins(plot: :developer)
            .where(resident: resident)
            .where(developers: { verified_association:
                                 Developer.verified_associations[developer] })
        }

  scope :accepted,
        lambda { |plots|
          joins(:resident)
            .where(plot_id: plots)
            .where.not(residents: { invitation_accepted_at: nil })
        }

  scope :invited,
        lambda { |plots|
          joins(:resident)
            .where(plot_id: plots)
            .where(residents: { invitation_accepted_at: nil })
        }

  # CRM SYNC CODE
  # create residents and plots - this code smells bad and would need to
  # be done properly on a proper implementation
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.create_residents(plots)
    error = nil
    PlotResidency.transaction do
      begin
        plots.each do |p|
          plot = Plot.find(p.id.to_i)
          p.residents&.each do |resident|
            res = Resident.new(resident.attributes)
            res.create_without_password
            pr = PlotResidency.create!(
              resident: res,
              plot: plot,
              role: resident.role,
              invited_by: RequestStore.store[:current_user]
            )
            ResidentInvitationService.call(
              pr,
              RequestStore.store[:current_user], plot.developer.to_s
            )
            res.developer_email_updates = true
            Mailchimp::MarketingMailService.call(res, plot,
                                                 res.activation_status)
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        error = e.message
      end

      yield error
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def self.role_call
    roles.map do |name, _|
      [name, I18n.t("activerecord.attributes.plot_residency.roles.#{name}")]
    end
  end

  # Plot receives Notifications if the development is Spaciable (native)
  # or its a Spaciable/Living (hybrid) development and the resident does
  # not have an account on Living
  def receives_notifications?
    return false if platform?(:living)

    !(platform?(:hybrid) && resident.living)
  end

  private

  def set_resident
    return if resident_id?

    self.resident = Resident.find_by(email: @email) || build_resident
  end

  def assign_resident_attributes
    attrs = %i[title first_name last_name email phone_number]
            .each_with_object({}) do |attr, acc|
      value = instance_variable_get("@#{attr}")
      acc[attr] = value if value.present?
    end

    resident.assign_attributes(attrs)
  end
end
