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

    visit "/developers/#{developer.id}"

  end

  def goto_division_show_page
    division = CreateFixture.division
    raise "Division does not exist" unless division

    visit "/developers/#{division.developer.id}/divisions/#{division.id}"

    within ".division" do
      expect(page).to have_content(division.to_s)
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

  def goto_development_phase_show_page
    phase = CreateFixture.phase
    raise "Phase does not exist" unless phase

    visit "/developments/#{CreateFixture.development.id}/phases/#{phase.id}"

    within ".phase" do
      expect(page).to have_content(phase.to_s)
    end
  end

  def goto_spanish_development_show_page
    development = CreateFixture.spanish_development
    raise "Development does not exist" unless development

    visit "/developers/#{development.developer.id}/developments/#{development.id}"

    within ".development" do
      expect(page).to have_content(development.to_s)
    end
  end

  def goto_plot_show_page
    goto_development_show_page

    within ".tabs" do
      click_on t("developments.collection.plots")
    end

    within ".plots" do
      click_on CreateFixture.plot_name
    end
  end

  def goto_phase_show_page
    goto_development_show_page

    within ".phases" do
      click_on CreateFixture.phase_name
    end
    page.find(".section-title").should have_content(CreateFixture.phase_name)

  end

  def goto_phase_plot_show_page
    goto_phase_show_page

    within ".plots" do
      click_on CreateFixture.phase_plot_name
    end
  end
end
