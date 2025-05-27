# frozen_string_literal: true

#rubocop:disable all
class CustomTile < ApplicationRecord
  include HTTParty
  include GuideEnum
  include AppearsEnum

  belongs_to :tileable, polymorphic: true
  belongs_to :spotlight

  mount_uploader :file, DocumentUploader
  mount_uploader :image, PictureUploader
  attr_accessor :image_cache
  attr_accessor :custom_snagging_name
  attr_accessor :file_added
  attr_accessor :dynamic
  attr_accessor :saved_original_filename
  attr_accessor :image_added
  attr_accessor :added_image_name

  delegate :development, to: :spotlight, allow_nil: true

  after_save :check_file

  #validate :meta
  validates :title, presence: true, unless: :feature?
  validates :description, presence: true, :unless => Proc.new { |ct| ct.feature? || !ct.render_description? }
  validates :button, presence: true, :unless => Proc.new { |ct| ct.feature? || !ct.render_button? }
  validates :link, presence: true, if: :link?
  validates :feature, presence: true, if: :feature?

  validate :proforma, if: :content_proforma?
  validate :document_sub_category, if: :document?
  validate :warn_reattach_file, if: :document?
  validate :warn_reattach_image
  delegate :development, to: :spotlight, allow_nil: true
  delegate :cf, to: :spotlight

  def parent
    spotlight
  end

  enum category: %i[
    feature
    document
    link
    content_proforma
  ]

  enum feature: {
    area_guide: 0,
    home_designer: 1,
    referrals: 2,
    services: 3,
    perks: 4,
    issues: 5,
    snagging: 6,
    timeline: 7,
    conveyancing: 8
  }

  def snag_name
    custom_snagging_name || spotlight&.snag_name || "Snagging"
  end

  def proforma
    return unless content_proforma?
    return if tileable.present?

    errors.add(:content_proforma, "is required, and must not be blank.")
    errors.add(:tileable_id, "please populate")
  end

  def document
    Document.find_by(id: document_id)
  end

  def document_sub_category
    return if guide.present? || file.present? || document_id.present?
    errors.add(:base, :document_sub_category_required)
  end

  def document_location(documents)
    if document_id
      document.file.url
    elsif guide
      doc = documents.find_by(guide: guide)
      doc.file.url
    elsif file
      file.url
    end
  end

  def active_feature(plot)
    return true unless snagging? || issues? || timeline? || conveyancing?
    return true if snagging? && plot.snagging_valid
    return true if issues? && plot.show_maintenance?
    return true if timeline? && plot&.journey&.live?
    return true if conveyancing? && plot.conveyancing_enabled?
    false
  end

  def proforma_assoc?(plot)
    return false unless tileable.is_a? Timeline
    PlotTimeline.matching(plot, tileable)&.present?
  end

  def active_document(documents)
    return true if file? || document_id?
    CustomTile.guides.each { | g, _ | return true if guide_populated(g, documents) }
    false
  end

  def guide_populated(guide, documents)
    return send("#{guide}?") && documents.find_by(guide: guide)
  end

  def iframeable?(link)
    false
  end

  def formatted_link
    link !~ /\A(http)/ ? "https://#{link}" : link
  end

  # process the params.  Note if a file param was added
  def process(params, is_dynamic, update = true)
    return if params.blank?
    @dynamic = is_dynamic
    @file_added = params["file"].present?
    @image_added = params["image"].present?
    @added_image_name = params["image"].original_filename if @image_added
    # save the original filename in case it needs to be displayed.  This is
    # persistent because the original file name is required for to 'show'
    # the custom tile
    @saved_original_filename = original_filename if update
  end

  def tab_title
    return nil unless @dynamic
    I18n.t("spotlights.form.tabs.#{order == 0 ? 'pre' : 'post'}")
  end

  # (Jira 754) If a file was added, and validation errors have been generated, then
  # the user will see a screen containing the values entered and individial errors
  # detailed at the head of the page.  If they added a file, then resubmission of the
  # form will NOT contain that added file and so they must be warned and told it must
  # be re-attached
  def warn_reattach_file
    return if errors.empty?
    return unless file_added

    # Yes it has, but there are other errors so will be lost - remind to reattach
    error = String.new("Please reattach #{self.original_filename}")
    error.concat(" to #{tab_title}") if tab_title
    errors.add(:file, error)
    # reset the 'original filename' field to that before the update
    # was made
    self.original_filename = self.saved_original_filename
  end

  # (Jira 754) If an image was added, and validation errors have been generated, then
  # the user will see a screen containing the values entered and individial errors
  # detailed at the head of the page.  If they added an image, then resubmission of the
  # form will NOT contain that added image and so they must be warned and told it must
  # be re-attached
  def warn_reattach_image
    return if errors.empty?
    return unless image_added

    # Yes it has, but there are other errors so will be lost - remind to reattach
    error = String.new("Please reattach #{self.added_image_name}")
    error.concat(" to #{tab_title}") if tab_title
    errors.add(:image, error)
  end

  # Remove any associated file unless the conditions for its
  # attachment are met
  def check_file
    return unless self.file.present?
    if !self.document? ||
       self.document_id.present? ||
       self.guide.present?
      self.remove_file!
    end
  end

end
#rubocop:enable all
