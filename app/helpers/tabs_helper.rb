# frozen_string_literal: true
module TabsHelper
  def room_tabs(room, current_tab)
    finishes_tab = Tab.new(
      title: t("rooms.collection.finishes"),
      icon: :building,
      link: room_path(room, active_tab: :finishes),
      active: (current_tab == "finishes")
    )

    appliances_tab = Tab.new(
      title: t("rooms.collection.appliances"),
      icon: :building,
      link: room_path(room, active_tab: :appliances),
      active: (current_tab == "appliances")
    )

    [finishes_tab, appliances_tab].map(&:to_a)
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
