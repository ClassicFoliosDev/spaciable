# frozen_string_literal: true
class User < ApplicationRecord
  acts_as_paranoid

  include PolymorphicPermissionable
  include PolymorphicPermissionable::ByRole
  permissionable_field :permission_level

  attr_accessor :developer_id, :division_id, :development_id
  belongs_to :permission_level, polymorphic: true

  # as home owner, maybe move these out?
  has_many :plot_residents
  has_many :plots, through: :plot_residents
  has_many :resident_notifications, foreign_key: :resident_id
  has_many :homeowner_notifications, through: :resident_notifications, source: :notification

  scope :admin, -> { where.not(role: :homeowner) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable,
         :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  enum role: [
    :cf_admin, # Client Folio Admin
    :developer_admin,
    :division_admin,
    :development_admin,
    :homeowner
  ]

  def self.admin_roles
    roles.reject { |key, _| key == "homeowner" }
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

  def to_s
    full_name = "#{first_name} #{last_name}"

    if full_name.strip.present?
      full_name
    else
      email
    end
  end
end
