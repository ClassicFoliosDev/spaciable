# frozen_string_literal: true

module DevelopmentTabsHelper
  include TabsHelper

  def development_tabs(development, current_tab)
    tabs = DEVELOPMENT_TABS.call(development)
    add_plot_tabs(tabs, development) if Rails.application.config.enable_development_plots
    Tabs.new(development, tabs, current_tab, self).all
  end

  DEVELOPMENT_TABS = lambda do |development|
    {
      unit_types: {
        icon: :building,
        link: [development.parent, development, active_tab: :unit_types]
      },
      phases: {
        icon: :building,
        link: [development.parent, development, active_tab: :phases]
      },
      documents: {
        icon: "file-pdf-o",
        link: [development.parent, development, active_tab: :documents]
      },
      faqs: { icon: "question-circle" },
      contacts: { icon: :vcard },
      brands: { icon: "css3" },
      videos: { icon: "file-video-o" },
      choice_configurations: {
        icon: "th-list",
        hide: development.choices_disabled?,
        link: [development.parent, development, active_tab: :choice_configurations]
      }
    }
  end

  def add_plot_tabs(tabs, development)
    tabs[:plots] = {
      icon: :building,
      link: [development.parent, development, active_tab: :plots]
    }

    tabs[:plot_documents] = {
      icon: "files-o",
      link: [development, :plot_documents]
    }
  end
end
