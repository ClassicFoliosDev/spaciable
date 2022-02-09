# frozen_string_literal: true

class Faq < ApplicationRecord
  include FaqPackageEnum

  belongs_to :faqable, polymorphic: true
  belongs_to :faq_type
  belongs_to :faq_category

  delegate :country, to: :faqable
  after_create :init

  attr_accessor :notify
  alias parent faqable

  after_update :cus

  validates :question, :answer, :faq_type, :faq_category, :faqable, presence: true

  delegate :to_s, to: :question
  delegate :name, to: :faq_type, prefix: :type
  delegate :name, to: :faq_category, prefix: :category
  delegate :categories, to: :faq_type

  scope :visible_to,
        lambda { |user, type|
          accessible_by(user).where(faq_type: type)
        }

  # rubocop:disable SkipsModelValidations
  def cus
    return unless changed?
    update_column(:faq_package, :custom)
  end
  # rubocop:enable SkipsModelValidations

  # rubocop:disable SkipsModelValidations
  def init
    update_column(:faq_package, :custom) if faq_package.blank?
  end
  # rubocop:enable SkipsModelValidations
end
