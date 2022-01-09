# frozen_string_literal: true

module TabsConcern
  extend ActiveSupport::Concern

  # Find the first populated library tab after the supplied category
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def first_populated_tab_after(_category)
    tabs = %w[my_home locality legal_and_warranty fire_safety appliances videos my_documents]

    (tabs.index(@category) + 1..tabs.size).each do |tab|
      case tabs[tab]
      when "appliances"
        return homeowner_appliance_manuals_path if Appliance.accessible_by(current_ability).any?
      when "videos"
        if !@plot.free? && @plot&.development&.videos&.where("created_at <= ?", @plot.expiry_date)
          return homeowner_videos_path
        end
      when "my_documents"
        return private_documents_path
      else
        return homeowner_library_path(tabs[tab]) if
          Document.accessible_by(current_ability)
                  .where(category: tabs[tab])
                  .where("created_at <= ?", @plot.expiry_date).any?
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
