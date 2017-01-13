# frozen_string_literal: true
module TabsHelper
  def developer_tabs(developer, current_tab)
    divisions_tab = Tab.new(
      title: t("developers.tabs.divisions"),
      icon: :building,
      link: developer_path(developer, active_tab: :divisions),
      active: (current_tab == "divisions")
    )

    developments_tab = Tab.new(
      title: t("developers.tabs.developments"),
      icon: :building,
      link: developer_path(developer, active_tab: :developments),
      active: (current_tab == "developments")
    )

    [divisions_tab, developments_tab].map(&:to_a)
  end

  class Tab
    attr_reader :title, :icon, :link, :active

    def initialize(title:, icon:, link:, active:)
      @title = title
      @icon = icon
      @link = link
      @active = active
    end

    def active?
      active == true
    end

    def to_a
      [title, icon, link, active?]
    end
  end
end
