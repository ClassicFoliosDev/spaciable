# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class User < ApplicationRecord
  acts_as_paranoid
  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache

  include PolymorphicPermissionable
  include PolymorphicPermissionable::ByRole
  permissionable_field :permission_level

  attr_accessor :developer_id, :division_id, :development_id

  belongs_to :permission_level, polymorphic: true
  delegate :expired?, to: :permission_level

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

  # Generate list of emails for snag notifications
  # Site admins do not have access to snagging and so do not receive snagging emails
  def self.users_associated_snags(associations)
    emails = []
    associations.each do |association|
      next if association.nil?
      details = User.where(snag_notifications: true)
                    .where(permission_level_type: association.class.to_s)
                    .where(permission_level_id: association.id)
                    .where.not(role: "site_admin").pluck(:email)
      details.each { |d| emails << { email: d } }
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

  # Get all the  users supplemented with their associated developer/division/development
  # names as appropriate.  The developer/division and development details have to be
  # selected from joined tables.  This could be done via a database view but we would
  # still need an SQL statement to populate it.  The exec_query method returns am
  # ActiveRecord::Result whereas the ruby 'magic' AcriveRecord statements return
  # ActiveRecord::Relation objects.  All the view pages are programmed around the Relation
  # class - in order for them to function for a Result we have to suppliement the class
  # with accessors that enable the pagination to work.  The way this function works is
  # not really in line with the other pages but unfortnately it doesn't fit the usualy model
  # rubocop:disable all
  def self.full_details(params, current_ability)
    per = (params[:per] || 25).to_i
    direction = params[:direction] || "ASC"
    sort = params[:sort] || "LOWER(users.email)"
    page = (params[:page] || 1).to_i
    offset = (page - 1) * per

    # Unfortunately the 'Devise' accessible_by method cannot be applied to a
    # the SQL statement as it is built around access to single tables.  In order
    # tp restrict the results to only thise accessible by the current_ability
    # we get an array of all the accessible users here, then plug them into the
    # SQL as an 'IN (....)'' parameter to restrict the results to only accessible users
    visible_users = User.all.accessible_by(current_ability).pluck(:id)

    sql = "SELECT users.*, developers.company_name, divisions.division_name, "\
          "developments.name as development_name from users LEFT OUTER JOIN developers ON "\
          "(users.permission_level_type='Developer' AND users.permission_level_id = "\
          "developers.id) OR (users.permission_level_type='Devision' and developers.id = "\
          "(SELECT developers.id from developers INNER JOIN divisions ON "\
          "divisions.developer_id = developers.id and divisions.id = users.permission_level_id) "\
          "OR (users.permission_level_type='Development' and developers.id = "\
          "(SELECT developers.id from developers INNER JOIN divisions ON divisions.developer_id= "\
          "developers.id INNER JOIN developments ON divisions.id = developments.division_id and "\
          "developments.id = users.permission_level_id ))) OR "\
          "(users.permission_level_type='Development' and developers.id = (SELECT developers.id "\
          "from developers INNER JOIN developments ON developments.developer_id = developers.id "\
          "AND developments.id=users.permission_level_id)) LEFT OUTER JOIN divisions ON "\
          "(users.permission_level_type='Division' AND users.permission_level_id = divisions.id) "\
          "OR (users.permission_level_type='Development' AND divisions.id = (SELECT divisions.id "\
          "from divisions INNER JOIN developments ON developments.division_id = divisions.id AND "\
          "developments.id = users.permission_level_id)) LEFT OUTER JOIN developments ON "\
          "users.permission_level_type='Development' AND users.permission_level_id = "\
          "developments.id where users.deleted_at is NULL and users.id IN "\
          "(#{visible_users.join(',')}) ORDER BY #{sort} #{direction} "\
          "LIMIT #{per} OFFSET #{offset}"
    users = ActiveRecord::Base.connection.exec_query(sql)

    # This data needs to appear like a ActiveRecord::Relation so that pagination can work.
    # The users variable will be an ActiveRecord::Result and neeeds pagination criterian adding
    class << users
      attr_accessor :total_pages
      attr_accessor :current_page
      attr_accessor :limit_value
    end
    users.current_page = page
    users.limit_value = per
    users.total_pages = (visible_users.size.to_f / per).ceil
    users
  end
  # rubocop:enable all
end
