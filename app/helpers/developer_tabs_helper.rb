# frozen_string_literal: true
module DeveloperTabsHelper
  include TabsHelper

  def developer_tabs(developer, current_tab)
    tabs = [
      divisions_tab(developer, current_tab),
      developments_tab(developer, current_tab),
      documents_tab(developer, current_tab),
      contacts_tab(developer, current_tab),
      faqs_tab(developer, current_tab)
    ].map(&:to_a)

    tabs.push(developer_brands_tab(developer, current_tab).to_a) if can? :read, Brand
    tabs
  end

  private

  def divisions_tab(developer, current_tab)
    Tab.new(
      title: t("developers.collection.divisions"),
      icon: :building,
      link: developer_path(developer, active_tab: :divisions),
      active: (current_tab == "divisions")
    )
  end

  def developments_tab(developer, current_tab)
    Tab.new(
      title: t("developers.collection.developments"),
      icon: :building,
      link: developer_path(developer, active_tab: :developments),
      active: (current_tab == "developments")
    )
  end

  def documents_tab(developer, current_tab)
    Tab.new(
      title: t("developers.collection.documents"),
      icon: "file-pdf-o",
      link: developer_path(developer, active_tab: :documents),
      active: (current_tab == "documents")
    )
  end

  def contacts_tab(developer, current_tab)
    Tab.new(
      title: t("developers.collection.contacts"),
      icon: :vcard,
      link: developer_contacts_path(developer),
      active: (current_tab == "contacts")
    )
  end

  def faqs_tab(developer, current_tab)
    Tab.new(
      title: t("developers.collection.faqs"),
      icon: "question-circle",
      link: developer_faqs_path(developer),
      active: (current_tab == "faqs")
    )
  end

  def developer_brands_tab(developer, current_tab)
    Tab.new(
      title: t("developers.collection.brands"),
      icon: "css3",
      link: developer_brands_path(developer),
      active: (current_tab == "brands")
    )
  end
end
