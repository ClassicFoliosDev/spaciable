# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
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

  scope :visible_to,
        lambda { |user|
          where("developer_id #{user.developer.nil? ? 'IS NULL' : '=' + user.developer.to_s}")
        }

  scope :with_cat_type_man,
        lambda { |params|
          joins(:finish_category, :finish_type, :finish_manufacturer)
            .where(finish_types: { id: params[:type] },
                   finish_categories: { id: params[:category] },
                   finish_manufacturers: { id: params[:manufacturer] })
            .order(:name)
        }

  scope :with_cat_type,
        lambda { |params|
          joins(:finish_category, :finish_type)
            .where(finish_types: { id: params[:type] },
                   finish_categories: { id: params[:category] })
            .order(:name)
        }

  scope :with_params,
        lambda { |params, developer|
          joins(:finish_type,
                :finish_category,
                :finish_manufacturer)
            .where(name: params[:name], developer_id: developer,
                   finish_types: { name: params[:type] },
                   finish_categories: { name: params[:category] },
                   finish_manufacturers: { name: params[:manufacturer] })
        }

  validates :name,
            presence: true,
            uniqueness:
            {
              scope: %i[finish_category finish_type finish_manufacturer developer],
              case_sensitive: false
            }

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

  # This function looks to find or create a finish using the names for a
  # finish/category/type/manufacturer.  It has to cover a number of scenarios
  # depending if the finish, category, type and manufacturer already exists
  # for the developer.  If not they are created as required.  Finally, if there is
  # a finish for the CF Admin with the name/category/type/manufacturer combination
  # and we are creating a new 'developer' version, then any image for the finish is
  # copied to the new developer finish
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.find_or_create(params, rooms)
    category = FinishCategory.find_or_create(params[:category], params[:developer_id])
    type = FinishType.find_or_create(params[:type], params[:developer_id], category)
    manufacturer = FinishManufacturer.find_or_create(params[:manufacturer],
                                                     params[:developer_id],
                                                     type)

    finish = Finish.find_or_initialize_by(finish_category_id: category.id,
                                          finish_type_id: type.id,
                                          finish_manufacturer_id: manufacturer&.id,
                                          name: params[:name],
                                          developer_id: params[:developer_id])

    finish.room_ids |= rooms # add/set unique rooms

    # Is is a new finish?
    if finish.new_record?
      # is there a matching CF finish with the name/cat/type/man and nil developer
      cf_finish = Finish.with_params(params, nil)
      if cf_finish.present?
        # copy attributes
        cf_finish = cf_finish[0]
        finish.original_filename = cf_finish.original_filename
        finish.picture = cf_finish.picture

        # and copy the image if there is one
        if cf_finish.original_filename.present?
          # create the folder
          base_folder = Rails.root.join("public", "uploads", "finish", "picture")
          FileUtils.mkdir_p "#{base_folder}/#{finish.id}"
          # copy the file
          FileUtils.cp "#{base_folder}/#{cf_finish.id}/#{cf_finish.original_filename}",
                       "#{base_folder}/#{finish.id}"
        end
      end
    end

    finish.save!
    finish
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
# rubocop:enable Metrics/ClassLength
