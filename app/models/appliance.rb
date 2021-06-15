# frozen_string_literal: true

class Appliance < ApplicationRecord
  acts_as_paranoid

  include PgSearch
  multisearchable against: %i[appliance_manufacturer_name model_num], using: %i[tsearch trigram]

  mount_uploader :primary_image, PictureUploader
  mount_uploader :secondary_image, PictureUploader
  mount_uploader :manual, DocumentUploader
  mount_uploader :guide, DocumentUploader

  attr_accessor :primary_image_cache
  attr_accessor :secondary_image_cache
  attr_accessor :name
  attr_accessor :added_by

  belongs_to :appliance_category, required: true
  has_many :choices, as: :choiceable
  belongs_to :appliance_manufacturer, required: true
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

  validates :model_num, presence: true,
                        uniqueness:
                        {
                          scope: %i[developer],
                          case_sensitive: false
                        }

  delegate :link, :name, to: :appliance_manufacturer, prefix: true

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

  def boiler?
    appliance_category.name == "Boiler"
  end
end
