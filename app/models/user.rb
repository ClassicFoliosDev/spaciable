# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid
  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache

  include PolymorphicPermissionable
  include PolymorphicPermissionable::ByRole
  permissionable_field :permission_level

  attr_accessor :developer_id, :division_id, :development_id

  belongs_to :permission_level, polymorphic: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable,
         :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
  include DeviseInvitable::Admin

  enum role: [
    :cf_admin, # Client Folio Admin
    :developer_admin,
    :division_admin,
    :development_admin,
    :site_admin
  ]

  def self.admin_roles
    roles.reject { |key, _| key == "homeowner" }
  end

  def permission_level_name
    return "Classic Folios" if permission_level.nil?
    permission_level
  end

  def self.accessible_admin_roles(user)
    admin_roles.select { |_, value| value >= roles[user.role] }
  end

  validates :role, :email, presence: true

  def create_without_password(**params)
    extend User::NoPasswordRequired

    params.delete(:password)
    params.delete(:password_confirmation)
    self.password = nil
    self.password_confirmation = nil

    assign_attributes(params)
    save
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

  # Generate the list of user emails/names that currently will receive release plot updates
  # for the supplied associations. Return the data in an array of hashes
  # e.g.
  # [{email: me@you.com, :first_name peter},
  #  {email: him@you.com, :first_name john}]
  def self.users_associated_with(assoiciations)
    emails = []
    assoiciations.each do |association|
      next if association.nil?
      details = User.where(receive_release_emails: true)
                    .where(permission_level_type: association.class.to_s)
                    .where(permission_level_id: association.id).pluck(:email, :first_name)

      details.each { |d| emails << { email:  d[0], first_name: d[1] } }
    end

    emails
  end

  # Admin users receiving choice emails
  def self.choice_enabled_admins_associated_with(assoiciations)
    admins = []
    assoiciations.each do |association|
      next if association.nil?
      admins << User.all.select do |u|
        u.receive_choice_emails == true &&
          u.permission_level_type == association.class.to_s &&
          u.permission_level_id == association.id
      end
    end

    admins.flatten!
  end

  # rubocop:disable all
  def enable_receive_release_emails?(current_user)
    current_user.cf_admin? ||
      (current_user.developer_admin? &&
       ((self == current_user) || division_admin? || development_admin? || site_admin?)) ||
      (current_user.division_admin? &&
        ((self == current_user) || development_admin? || site_admin?))
  end
  # rubocop:enable all

  # rubocop:disable all
  def enable_choice_emails?(current_user)
    true
  end
  # rubocop:enable all
end
