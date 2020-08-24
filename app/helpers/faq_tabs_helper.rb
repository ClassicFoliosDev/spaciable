# frozen_string_literal: true

module FaqTabsHelper
  class FaqMenuBuilder
    def menus_for(scope)
      menus = []
      scope.faq_types.each do |faq_type|
        menus << { icon: faq_type.icon,
                   title: faq_type.name,
                   link: [scope, :faqs, active_tab: faq_type.id] }
      end
      menus
    end
  end
end
