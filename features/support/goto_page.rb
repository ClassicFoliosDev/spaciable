# frozen_string_literal: true

module GotoPage
  def goto_resource_show_page(parent, resource)
    resource = "Developer" if resource == "CF" # assume top level
    resource_name = CreateFixture.ResourceName(resource, parent)

    send("goto_#{resource_name}_show_page")
  end

  def goto_developer_show_page
    developer = CreateFixture.developer
    raise "Developer does not exist" unless developer

    within ".navbar" do
      click_on t("components.navigation.developers")
    end

    within ".developers" do
      click_on developer
    end
  end

  def goto_division_show_page
    division = CreateFixture.division
    raise "Division does not exist" unless division

    goto_developer_show_page

    within ".divisions" do
      click_on division
    end
  end

  def goto_division_development_show_page
    division_development = CreateFixture.division_development
    raise "Division Development does not exist" unless division_development

    goto_division_show_page

    within ".developments" do
      click_on division_development
    end
  end

  def goto_development_show_page
    development = CreateFixture.development
    raise "Development does not exist" unless development

    visit "/developers/#{development.developer.id}/developments/#{development.id}"

    within ".development" do
      expect(page).to have_content(development.to_s)
    end
  end

  def goto_development_phase_page
    development = CreateFixture.development
    raise "Development does not exist" unless development

    goto_development_show_page

    within ".tabs" do
      click_on t("developments.collection.phases")
    end

    within ".phases" do
      click_on CreateFixture.phase_name
    end
  end

  def goto_plot_show_page
    goto_development_show_page

    within ".tabs" do
      click_on t("developments.collection.plots")
    end

    within ".record-list" do
      click_on CreateFixture.plot_name
    end
  end

  def goto_phase_show_page
    goto_development_show_page

    within ".tabs" do
      click_on t("developments.collection.phases")
    end

    within ".phases" do
      click_on CreateFixture.phase_name
    end
  end

  def goto_phase_plot_show_page
    goto_phase_show_page

    within ".tabs" do
      click_on t("phases.collection.plots")
    end

    within ".record-list" do
      click_on CreateFixture.phase_plot_name
    end
  end
end
