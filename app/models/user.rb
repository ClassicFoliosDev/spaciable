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
end
