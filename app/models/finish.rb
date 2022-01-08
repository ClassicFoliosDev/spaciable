# frozen_string_literal: true

class Finish < ApplicationRecord
  require "fileutils"

  acts_as_paranoid

  include PgSearch
  multisearchable against: %i[full_name],
                  using: %i[tsearch trigram]

  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache
  attr_accessor :added_by

  belongs_to :finish_category, required: true
  belongs_to :finish_type, required: true
  belongs_to :finish_manufacturer
  belongs_to :developer, optional: true

  has_many :finish_rooms, inverse_of: :finish, dependent: :delete_all
  has_many :rooms, through: :finish_rooms
  has_many :choices, as: :choiceable

  delegate :name, to: :finish_category, prefix: true
  delegate :name, to: :finish_type, prefix: true
  delegate :name, to: :finish_manufacturer, prefix: true

  scope :with_cat_type_man,
        lambda { |params|
          finishes =
            Finish.joins(:finish_category, :finish_type, :finish_manufacturer)
                  .where(finish_types: { id: params[:type] },
                         finish_categories: { id: params[:category] },
                         finish_manufacturers: { id: params[:manufacturer] })

          if RequestStore.store[:current_user].cf_admin?
            finishes = finishes.where(developer_id: nil)
          else
            finishes =
              finishes.where(developer_id: [nil, RequestStore.store[:current_user].developer])
          end

          finishes.order(:name)
        }

  scope :with_cat_type,
        lambda { |params|
          finishes =
            Finish.joins(:finish_category, :finish_type)
                  .where(finish_types: { id: params[:type] },
                         finish_categories: { id: params[:category] })

          if RequestStore.store[:current_user].cf_admin?
            finishes = finishes.where(developer_id: nil)
          else
            finishes =
              finishes.where(developer_id: [nil, RequestStore.store[:current_user].developer])
          end

          finishes.order(:name)
        }

  scope :filtered,
        lambda { |filter, ability|
          finishes = accessible_by(ability)
                     .includes(:finish_category, :finish_type, :finish_manufacturer)

          %i[finish_category_id finish_type_id finish_manufacturer_id].each do |f|
            finishes = finishes.where(f => filter.send(f)) if filter.send(f)
          end

          finishes
        }

  validates :name, presence: true

  validate :check_dup

  def check_dup
    return unless RequestStore.store[:current_user]&.is_a? User
    developer_ids = [developer_id]
    developer_ids << nil unless RequestStore.store[:current_user]&.cf_admin?

    return if Finish.where(finish_category_id: finish_category_id,
                           finish_type_id: finish_type_id,
                           finish_manufacturer_id: finish_manufacturer_id,
                           name: name,
                           developer_id: developer_ids)
                    .where.not(id: id).count.zero?

    errors.add(:finish, I18n.t("finishes.duplicate.message"))
  end

  def to_s
    name
  end

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end

  def set_original_filename
    self.original_filename = picture.filename
    save!
  end

  def full_name
    "#{finish_manufacturer&.name} #{name} #{finish_type&.name}".strip
  end

  def short_name
    name
  end

  def in_use?
    FinishRoom.with_finish(id).present?
  end
end
