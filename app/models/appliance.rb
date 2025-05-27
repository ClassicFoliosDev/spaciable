# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength, Rails/HasManyOrHasOneDependent
class Appliance < ApplicationRecord
  acts_as_paranoid

  include PgSearch
  multisearchable against: %i[appliance_manufacturer_name model_num], using: %i[tsearch trigram]

  mount_uploader :primary_image, PictureUploader
  alias picture primary_image
  alias picture? primary_image?
  mount_uploader :secondary_image, PictureUploader
  mount_uploader :manual, DocumentUploader
  mount_uploader :guide, DocumentUploader

  after_update :update_rating

  attr_accessor :primary_image_cache
  attr_accessor :secondary_image_cache
  attr_accessor :name
  attr_accessor :added_by

  belongs_to :appliance_category, optional: false
  has_many :choices, as: :choiceable
  belongs_to :appliance_manufacturer, optional: false
  belongs_to :developer, optional: true

  has_many :appliance_rooms, dependent: :delete_all
  has_many :rooms, through: :appliance_rooms

  paginates_per 10

  scope :with_cat_man,
        lambda { |params, user|
          joins(:appliance_category, :appliance_manufacturer)
            .where(appliance_categories: { id: params[:category] },
                   appliance_manufacturers: { id: params[:manufacturer] })
            .where("(appliances.developer_id IS NULL AND (select count(*) from appliances a " \
                   "where a.model_num = appliances.model_num AND a.developer_id = ?) = 0) OR " \
                   "(appliances.developer_id IS NOT NULL AND appliances.developer_id = ?)",
                   user.developer,
                   user.developer)
            .order(:model_num)
        }

  scope :filtered,
        lambda { |filter, ability|
          appliances = accessible_by(ability)
                       .includes(:appliance_category, :appliance_manufacturer)

          %i[appliance_category_id appliance_manufacturer_id].each do |f|
            appliances = appliances.where(f => filter.send(f)) if filter.send(f)
          end

          appliances
        }

  scope :in_rooms,
        lambda { |rooms|
          joins(:appliance_rooms)
            .where(appliances_rooms: { room_id: rooms })
        }

  validates :model_num, presence: true

  validate :check_dup

  delegate :link, :name, to: :appliance_manufacturer, prefix: true
  delegate :register, to: :appliance_category
  delegate :washer_dryer?, to: :appliance_category

  enum warranty_length: %i[
    no_warranty
    one
    two
    three
    four
    five
    six
    seven
    eight
    nine
    ten
  ]

  enum e_rating: %i[
    a3
    a2
    a1
    a
    b
    c
    d
  ]

  enum main_uk_e_rating: %i[
    a
    b
    c
    d
    e
    f
    g
  ], _prefix: :main_e_rating

  enum supp_uk_e_rating: %i[
    a
    b
    c
    d
    e
    f
    g
  ], _prefix: :supp_e_rating

  def check_dup
    return unless RequestStore.store[:current_user]&.is_a? User

    developer_ids = [developer_id]
    developer_ids << nil unless RequestStore.store[:current_user]&.cf_admin?

    return if Appliance.where(appliance_category_id: appliance_category_id,
                              appliance_manufacturer_id: appliance_manufacturer_id,
                              model_num: model_num,
                              developer_id: developer_ids)
                       .where.not(id: id).count.zero?

    errors.add(:appliance, I18n.t("appliances.duplicate.message"))
  end

  def short_name
    full_name
  end

  def full_name
    "#{appliance_manufacturer&.name} #{model_num}".strip
  end

  def to_s
    full_name
  end

  def in_use?
    ApplianceRoom.with_appliance(id).present?
  end

  def as_json(options = {})
    h = super(options)
    h[:name] = full_name
    h
  end

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end

  # rubocop:disable SkipsModelValidations
  def update_rating
    return if e_rating.blank?
    return unless saved_change_to_main_uk_e_rating? || saved_change_to_supp_uk_e_rating?

    update_attribute(:e_rating, nil)
  end
  # rubocop:enable SkipsModelValidations
end
# rubocop:enable Metrics/ClassLength, Rails/HasManyOrHasOneDependent
