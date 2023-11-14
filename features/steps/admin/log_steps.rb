When(/^I should see no unit type logs$/) do
  visit "/unit_types/#{CreateFixture.unit_type.id}/rooms"
  within ".tabs" do
    expect(page).not_to have_content t("unit_types.collection.logs")
  end
end

When(/^I should see unit type logs$/) do
  visit "/unit_types/#{CreateFixture.unit_type.id}/rooms"
  within ".tabs" do
    expect(page).to have_content t("unit_types.collection.logs")
  end
end

And(/^I should see a (.*) (.*) log entry created by (.*)/) do |item, action, user|
  goto_ut_logs
  within ".record-list" do
    allfound = false
    page.all(:xpath, "//tbody/tr") do |row|
      next if allfound
      allfound = false
      row.find(:xpath, "td[text()[contains(.,'#{eval(item)}')]]")
      row.find(:xpath, "td[text()[contains(.,'#{action.capitalize()}')]]")
      row.find(:xpath, "td[text()[contains(.,'#{eval(user)}')]]")
      allfound = true
      break
    rescue => error
      # try again
      next
    end

    expect(allfound).to eql true
  end
end

When(/^I add a finish to the unit type room$/) do
  visit "/unit_types/#{CreateFixture.unit_type.id}/rooms"
  within ".record-list" do
    click_on CreateFixture.kitchen_name
  end

  within ".empty" do
    click_on "Assign Finish"
  end

  within ".search-finish" do
    fill_in "finish_room_search_finish_text", with: CreateFixture.finish_name
    find(".search-finish-btn", visible: true).trigger(:click)
  end

  within ".finish" do
    finish = Finish.find_by(name: CreateFixture.finish_name)
    find("#finishes", visible: false) # to wait for JS to create
    select_from_selectmenu :finishes, with: finish.full_name
  end

  within ".form-actions-footer" do
    click_on t("plots.rooms.form.submit")
  end
end

When(/^I delete a finish from the unit type room$/) do
  visit "/unit_types/#{CreateFixture.unit_type.id}/rooms/#{CreateFixture.room(CreateFixture.kitchen_name).id}?active_tab=finishes"
  delete_scope = find(:xpath, "//a[contains(text(),'#{CreateFixture.finish_name}')]/parent::td/parent::tr")
  within delete_scope do
    if delete_scope.has_css?('.archive-lnk')
      delete_and_confirm_lnk!(scope: delete_scope)
    else
      find(".remove").click
    end
  end
end

When(/^I add an appliance to the unit type room$/) do
  visit "/unit_types/#{CreateFixture.unit_type.id}/rooms/#{CreateFixture.room(CreateFixture.kitchen_name).id}?active_tab=appliances"

  within ".empty" do
    click_on "Assign Appliance"
  end

  within ".search-appliance" do
    fill_in "appliance_room_search_appliance_text", with: CreateFixture.appliance_name
    find(".search-appliance-btn", visible: true).trigger(:click)
  end

  within ".appliance" do
    appliance = Appliance.find_by(model_num: CreateFixture.appliance_name)
    find("#appliances", visible: false) # to wait for JS to create
    select_from_selectmenu :appliances, with: appliance.full_name
  end

  within ".form-actions-footer" do
    click_on t("plots.rooms.form.submit")
  end
end

When(/^I delete an appliance from the unit type room$/) do
  visit "/unit_types/#{CreateFixture.unit_type.id}/rooms/#{CreateFixture.room(CreateFixture.kitchen_name).id}?active_tab=appliances"
  delete_scope = find(:xpath, "//a[contains(text(),'#{CreateFixture.appliance_name}')]/parent::td/parent::tr")
  within delete_scope do
    find(".remove").trigger(:click)
  end
end

When(/^I delete a unit type room$/) do
  visit "/unit_types/#{CreateFixture.unit_type.id}/rooms"
  delete_scope = find(:xpath, "//a[contains(text(),'#{CreateFixture.kitchen_name}')]/parent::td/parent::tr")
  delete_and_confirm!(scope: delete_scope)
  sleep 1
end

When(/^I should see no logs for (.*)$/) do |plot|
  visit "/plots/#{eval(plot).id}?active_tab=rooms"

  within ".tabs" do
    expect(page).not_to have_content t("unit_types.collection.logs")
  end
end

def goto_ut_logs
  visit "/developments/#{CreateFixture.development.id}/unit_types/#{CreateFixture.unit_type.id}?active_tab=logs"
  page.find("a.active").should have_content(t("unit_types.collection.logs"))
end

def goto_plot_logs(plot)
  visit "/plots/#{plot.id}?active_tab=logs&per=100"
end

And(/^I should see a (.*) (.*) plot log entry for (.*) created by (.*)/) do |item, action, plot, user|
  origin = URI.parse(current_url).path # where did I come from?
  goto_plot_logs(eval(plot))

  within ".record-list" do
   find(:xpath, ".//tr[td//text()[contains(., '#{eval(item)}')] and contains(., '#{action.capitalize()}') and contains(., '#{eval(user)}')]")
  end
  visit origin # back to where I came from
end

When(/^I look at the data$/) do
  byebug
end
