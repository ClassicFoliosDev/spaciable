# frozen_string_literal: true

class Service < ApplicationRecord
  acts_as_paranoid

  has_many :resident_services, dependent: :delete_all
  has_many :residents, through: :resident_services

  enum category: %i[
    removals
    finance
    legal
    utilities
    estate
    manager
  ]

  def to_s
    return name if name.present?

    I18n.t("activerecord.attributes.service.categories.#{category}")
  end

  def selected?(resident)
    return true if residents.include? resident
    false
  end

  def to_description_s
    return description if description.present?

    I18n.t("activerecord.attributes.service.category_descriptions.#{category}_html")
  end

  def to_dashboard_s
    I18n.t("activerecord.attributes.service.dashboard_descriptions.#{category}_html")
  end

  def to_dashboard_title_s
    I18n.t("activerecord.attributes.service.dashboard_titles.#{category}")
  end
end
