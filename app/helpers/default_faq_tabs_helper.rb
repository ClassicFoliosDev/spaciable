# frozen_string_literal: true

module DefaultFaqTabsHelper
  include TabsHelper

  def default_faq_tabs(current_type)
    tabs = []
    FaqType.for_country(current_type.country).each do |faq_type|
      tabs << Tab.new(
        icon: faq_type.icon,
        active: current_type == faq_type,
        title: faq_type.name,
        link: admin_settings_default_faqs_path(active_tab: faq_type.id)
      ).to_a
    end
    tabs
  end
end
