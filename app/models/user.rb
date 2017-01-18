# frozen_string_literal: true
class User < ApplicationRecord
  acts_as_paranoid

  attr_accessor :developer_id, :division_id, :development_id
  belongs_to :permission_level, polymorphic: true

  # as home owner, maybe move these out?
  has_many :plot_residents
  has_many :plots, through: :plot_residents

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
  validate :permission_level_presence, unless: -> { cf_admin? || homeowner? }

  before_validation :set_permission_level, if: -> { developer_id || division_id || development_id }

  def permission_level_presence
    return if permission_level

    if developer_admin?
      errors.add(:developer_id, :blank)
    elsif division_admin?
      errors.add(:division_id, :blank)
    elsif development_admin?
      errors.add(:development_id, :blank)
    end
  end

  def set_permission_level
    perm_id, perm_type = if developer_admin?
                           [developer_id, "Developer"]
                         elsif division_admin?
                           [division_id, "Division"]
                         elsif development_admin?
                           [development_id, "Development"]
                         end

    self.permission_level_id = perm_id
    self.permission_level_type = perm_type
  end

  def populate_permission_ids
    return unless permission_level

    case permission_level
    when Developer
      self.developer_id = permission_level_id
    when Division
      self.division_id = permission_level_id
      self.developer_id = permission_level.developer_id
    when Development
      self.development_id = permission_level.id
      self.division_id = permission_level.division_id
      self.developer_id = permission_level.developer_id
    end
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

  def to_s
    full_name = "#{first_name} #{last_name}"

    if full_name.strip.present?
      full_name
    else
      email
    end
  end
end
