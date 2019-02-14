# frozen_string_literal: true

class HowTo < ApplicationRecord
  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache

  has_many :how_to_tags
  has_many :tags, through: :how_to_tags
  belongs_to :how_to_sub_category
  belongs_to :country
  accepts_nested_attributes_for :tags, reject_if: :all_blank, allow_destroy: true

  scope :active, -> { where.not(hide: true) }

  # Add the spanish categories.  This enum is associated with the category_id in the how_to table.
  # We put in ukp[n] entries as placeholders.  In the future we may want  to add more UK categories
  # and at that point we can rename them.  Any Spanish categories will retain their higher numbers
  # in the database
  enum category: %i[
    home
    diy
    lifestyle
    recipes
    cleaning
    outdoors
    ukp1
    ukp2
    ukp3
    ukp4
    ukp5
    buying
    furnishing
    runningcosts
    rental
    permanentliving
  ]

  enum feature_numbers: { "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5 }

  validates :title, :summary, :description, presence: true
  # Featured to to be unique within country
  validates :featured, uniqueness: { scope: :country_id }, if: -> { featured.present? }

  delegate :to_s, to: :title
  delegate :tag_attributes, to: :tags

  paginates_per 25

  def read_size
    size = Math.log(description.length, 30).to_i
    size = 0.5 if size < 1
    size
  end

  def build_tags
    tags.build
  end

  # Save comma-separated tag name as multiple tags
  def save_tags(how_to_params)
    tags_params = how_to_params.delete(:tags_attributes)
    return unless tags_params
    return how_to_params unless self

    tags_params.each do |tag_id|
      tag_param = tags_params[tag_id]
      next if tag_param[:name].blank?
      tag_names = tag_param.delete(:name).split(",")
      tag_names.each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name.strip)
        HowToTag.find_or_create_by(tag: tag, how_to: self)
      end
    end

    how_to_params
  end

  # The save_tags method above works well for update, but on create it has to be called after
  # the how_to object has been created, which in turn means that there is a duplicate
  # tag created when there are comma-separated tags
  # Compensate here by removing the tag if it contains a comma
  def delete_duplicate_tags
    tags.each do |tag|
      tags.destroy(tag) if tag.name.index(",").present?
    end
  end

  # Slice out just the categories for the country.  This is used to populate pulldowns and
  # lists in forms
  def self.country_categories(country)
    range = country.uk? ? (0..5) : (11..15)
    country_categories = []
    categories.each do |name, value|
      country_categories << name if range.include?(value)
    end

    # Return country_categories.  If you put an explicit return statement, rubocop complains.
    # If you leave this out then the 'default' return is 'categories' .. the last excuting
    # statement
    country_categories
  end
end
