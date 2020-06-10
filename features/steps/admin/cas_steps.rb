Then(/^I should see the standard list of finishes$/) do
  visit "/"

  click_on t("components.navigation.finishes")
  find(".tabs")

  finishes_file = "#{Rails.root}/config/Finishes.csv"
  # go through the file and confirm that there is row containing each item's details
  CSV.parse(File.read(finishes_file), headers: true).each do |finish|
    find_finish(finish[0], finish[1], finish[2], finish[3])
  end
end

When(/^I enable CAS for the developer$/) do
  visit "/developers/#{CreateFixture.developer.id}/edit"
  check "developer_cas"
  click_on t("developers.form.submit")
end

Given(/^I have a developer with a development with unit types and plots with rooms and finishes$/) do
  CreateFixture.create_developer_with_division
  CreateFixture.create_division_development
  CreateFixture.create_finishes
  ut = CreateFixture.create_division_development_unit_type(restricted: true)
  CreateFixture.create_unit_type_rooms(ut.name)
  CreateFixture.create_finish_room(CreateFixture.room(CreateFixture.bedroom_name, ut), CreateFixture.finish("red"))
  CreateFixture.create_finish_room(CreateFixture.room(CreateFixture.bathroom_name, ut), CreateFixture.finish("purple"))
  CreateFixture.create_finish_room(CreateFixture.room(CreateFixture.kitchen_name, ut), CreateFixture.finish("blue"))
  CreateFixture.create_finish_room(CreateFixture.room(CreateFixture.kitchen_name, ut), CreateFixture.finish("Azure"))
  CreateFixture.create_finish_room(CreateFixture.room(CreateFixture.lounge_name, ut), CreateFixture.finish("bluebell"))

  ut2 = CreateFixture.create_division_development_unit_type(CreateFixture.second_unit_type_name)
  CreateFixture.create_unit_type_rooms(ut2.name)
  CreateFixture.create_finish_room(CreateFixture.room(CreateFixture.bedroom_name, ut2), CreateFixture.finish("red"))
  CreateFixture.create_finish_room(CreateFixture.room(CreateFixture.bathroom_name, ut2), CreateFixture.finish("purple"))
  CreateFixture.create_finish_room(CreateFixture.room(CreateFixture.bathroom_name, ut2), CreateFixture.finish("Azure"))
  CreateFixture.create_finish_room(CreateFixture.room(CreateFixture.kitchen_name, ut2), CreateFixture.finish("green"))
  CreateFixture.create_finish_room(CreateFixture.room(CreateFixture.kitchen_name, ut2), CreateFixture.finish("Clown"))

  CreateFixture.create_division_development_phase
  CreateFixture.create_division_phase_plot
  CreateFixture.create_division_phase_plot(CreateFixture.phase_plot2_name, ut2)
  CreateFixture.create_division_phase_plot(CreateFixture.phase_plot3_name, ut2)
end

When(/^plot (.*) is completed$/) do |plot_number|
  Plot.find_by(number: eval(plot_number)).update_attribute(:completion_release_date, Time.zone.now.to_date)
end

When(/^(.*) has a (.*) room with a (.*) finish$/) do |plot_number, room_name, finish_name|

  plot = CreateFixture.plot(eval(plot_number))

  # go to the rooms for the plot
  visit "/plots/#{plot.id}?active_tab=rooms"

  # look for the room
  room = plot.rooms.find_by(name: eval(room_name))

  # if the room is missing
  if room.nil?
    # add it
    click_on t("rooms.collection.add")
    fill_in :room_name, with: eval(room_name)
    click_on t("plots.rooms.form.submit")
    room = plot.rooms.find_by(name: eval(room_name))
  end

  # identify the row
  within find(:xpath, ".//tr[td//text()[contains(., '#{eval(room_name)}')]]") do
    # select it
    click_on eval(room_name)
  end

  # add the finish
  find(:xpath, ".//a[contains(text(), '#{t("plots.rooms.collection.finishes")}')]")
  click_on t("finishes.collection.assign")

  within ".search-finish" do
    fill_in "finish_room_search_finish_text", with: finish_name
    find(".search-finish-btn", visible: true).trigger(:click)
  end

  within ".finish" do
    finish = Finish.find_by(name: finish_name)
    find("#finishes", visible: all) # to wait for JS to create
    select_from_selectmenu :finishes, with: finish.full_name
  end

  within ".form-actions-footer" do
    click_on t("plots.rooms.form.submit")
  end

end

When(/^I should see a developer copy of the (.*) finish$/) do |finish_name|
  visit "/finishes"
  developer = $current_user.developer
  cf_finish = CreateFixture.finish(finish_name)

  find_finish(finish_name,
              cf_finish.finish_category.name,
              cf_finish.finish_type.name,
              cf_finish.finish_manufacturer.name)

  expect(FinishCategory.find_by(name: cf_finish.finish_category.name, developer_id: developer)).not_to eql(nil)
  expect(FinishType.find_by(name: cf_finish.finish_type.name, developer_id: developer)).not_to eql(nil)
  expect(FinishManufacturer.find_by(name: cf_finish.finish_manufacturer.name, developer_id: developer)).not_to eql(nil)

end

When(/^I should not see a developer copy of the (.*) finish$/) do |finish_name|
  visit "/finishes"
  developer = $current_user.developer
  expect(Finish.find_by(name: finish_name, developer_id: developer)).to eql(nil)
end

Then(/^plot (.*) rooms are using (.*) finishes$/) do |plot_name, developer|
  rooms = CreateFixture.plot(eval(plot_name)).rooms
  developer = developer == "cf_admin" ? nil : $current_user.developer
  rooms.each do |room|
    room.finishes { |finish| expect(finish.developer_id).to equ(developer) }
  end
end

Then(/^I update the unit_type for plot (.*) to (.*)$/) do |plot_name, unit_type_name|
  visit "/plots/#{CreateFixture.plot(eval(plot_name)).id}/edit"
  find(".plot_unit_type")
  select eval(unit_type_name), visible: false
  click_on t("unit_types.form.submit")
end

def find_finish(name, category, type, manufacturer)
  find(:xpath, ".//tr[td//text()[contains(., '#{name}')] \
                  and contains(., '#{category}') \
                  and contains(., '#{type}') \
                  and contains(., '#{manufacturer}')]")

end

