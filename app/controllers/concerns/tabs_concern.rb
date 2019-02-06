# frozen_string_literal: true

module TabsConcern
  extend ActiveSupport::Concern

  # Find the first populated library tab after the supplied category
  # Method needs to be tidied to conform to rubocop rules, if possible

  # rubocop:disable MethodLength
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  def first_populated_tab_after(_category)
    tabs = %w[my_home locality legal_and_warranty appliances videos my_documents]

    (tabs.index(@category) + 1..tabs.size).each do |tab|
      case tabs[tab]
      when "locality"
        return homeowner_library_path("locality") if
          Document.accessible_by(current_ability).where(category: "locality").any?
      when "legal_and_warranty"
        return homeowner_library_path("legal_and_warranty") if
          Document.accessible_by(current_ability).where(category: "legal_and_warranty").any?
      when "appliances"
        return homeowner_appliance_manuals_path if Appliance.accessible_by(current_ability).any?
      when "videos"
        return homeowner_videos_path if @plot&.development&.videos&.any?
      when "my_documents"
        return private_documents_path
      end
    end
    # rubocop:enable MethodLength
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
  end
end
