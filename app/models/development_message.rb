# frozen_string_literal: true

class DevelopmentMessage < ApplicationRecord
  belongs_to :parent
  belongs_to :development
  belongs_to :resident

  validates :content, presence: true, length: { maximum: 255 }
  validate :subject_or_parent

  def children
    DevelopmentMessage.where(parent_id: id)
  end

  def subject_or_parent
    return if subject.present?
    return if parent_id.present?

    errors.add(:base, :must_have_subject)
  end

  scope :last_three_months, lambda {
    where("created_at > ?", (Time.zone.now - 3.months).beginning_of_day)
  }
  scope :primary, -> { where.not(subject: nil) }
end
