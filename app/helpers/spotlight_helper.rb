# frozen_string_literal: true

module SpotlightHelper
  def visible_to_free(spotlight)
    return false unless spotlight.cf?

    spotlight.custom_tiles.each do |tile|
      return false if %w[home_designer perks snagging].include?(tile.feature)
    end
    true
  end

  def feature_disabled(spotlight)
    disabled = []
    p = spotlight.parent

    { "area_guide" => p.house_search, "services" => p.enable_services,
      "home_designer" => p.enable_roomsketcher, "issues" => p.maintenance,
      "referrals" => p.enable_referrals, "perks" => p.enable_perks,
      "snagging" => p.enable_snagging, "timeline" => p.timeline,
      "conveyancing" => p.conveyancing_enabled? }.each do |name, feature|
      disabled << name unless feature
    end

    disabled
  end

  def appears_help(spotlight, appears)
    case appears.to_sym
    when :moved_in
      unsanitized t("spotlight.moved_in")
    when :completed
      if spotlight.development.phases.first
        return unsanitized t("spotlight.completed",
                             url: development_phase_path(spotlight.development,
                                                         spotlight.development.phases.first))
      end
      unsanitized t("spotlight.completed_e")
    end
  end

  def spotlight_types
    Spotlight.categories.map do |(key, _)|
      [t("activerecord.attributes.spotlights.category.#{key}"), key]
    end
  end

  def expiries_collection
    Spotlight.expiries.map do |(tag_name, _)|
      [t("activerecord.attributes.custom_tiles.expiries.#{tag_name}"), tag_name]
    end
  end
end
