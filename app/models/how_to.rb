# frozen_string_literal: true
class HowTo < ApplicationRecord
  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache

  has_many :how_to_tags
  has_many :tags, through: :how_to_tags
  belongs_to :how_to_sub_category
  accepts_nested_attributes_for :tags, reject_if: :all_blank, allow_destroy: true

  enum category: [:home, :diy, :lifestyle, :recipes, :cleaning, :outdoors]
  enum feature_numbers: { "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6 }

  validates :title, :summary, :description, presence: true
  validates :featured, uniqueness: true, if: -> { featured.present? }

  delegate :to_s, to: :title
  delegate :tag_attributes, to: :tags

  paginates_per 25

  def read_size
    Math.log(description.length).to_i
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
      next unless tag_param[:name].present?
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
end
