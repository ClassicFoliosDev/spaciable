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

  #validate :meta
  validates :appears_after_date, presence: true, :if => Proc.new { |ct| ct.emd_date? }
  validates :title, presence: true, unless: :feature?
  validates :description, presence: true, :unless => Proc.new { |ct| ct.feature? || !ct.render_description? }
  validates :button, presence: true, :unless => Proc.new { |ct| ct.feature? || !ct.render_button? }
  validate :proforma, if: :content_proforma?
  validates :link, presence: true, if: :link?
  validate :document_sub_category, if: :document?
  validates :feature, presence: true, if: :feature?
  delegate :development, to: :spotlight, allow_nil: true

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

  delegate :snag_name, to: :spotlight, allow_nil: true

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
    return false if HTTParty.get(link, verify: false).headers.key?("x-frame-options")
    true
  rescue
    false
  end

  def formatted_link
    link !~ /\A(http)/ ? "https://#{link}" : link
  end

  def expired?(plot)
    return true unless plot.completion_date?

    case expiry
    when :one_year.to_s
      Time.zone.today > (plot.completion_date + 1.year)
    when :to_year.to_s
      Time.zone.today > (plot.completion_date + 2.years)
    else
      false
    end
  end
end
#rubocop:enable all
