Then(/^I have seeded the timeline$/) do
  TimelineFixture.seed_timeline
end

Then(/^I can create a (.*) timeline$/) do |title|
  visit "/"
  click_on t("components.navigation.timeline")
  expect(page).to have_content("You have no timelines")

  click_on t("timelines.collection.create")
  fill_in "timeline[title]", with: eval(title)
  click_on t("timelines.form.submit")
end

Then(/^I can see the (.*) timeline (.*) successfully$/) do |title, _|
  check_success_add(eval(title))
end

Then(/^I can edit the (.*) timeline to (.*)$/) do |title, new_title|
  visit "/"
  click_on t("components.navigation.timeline")

  scope = find(:xpath, "//a[text()='#{eval(title)}']/parent::td/parent::tr")
  within scope do
    find("[data-action='edit']").click
  end

  fill_in "timeline[title]", with: eval(new_title)
  click_on t("timelines.form.submit")
end

When(/^I show the (.*) timeline$/) do |title|
  visit "/"
  click_on t("components.navigation.timeline")
  click_on eval(title)
end

When(/^the (.*) timeline has no tasks$/) do |title|
  within ".section-title" do
    expect(page).to have_content(eval(title))
  end

  expect(page).to have_content(t("tasks.show.empty_cf"))
end

When(/^I (.*) the (.*) task into (.*)$/) do |action, task_title, timeline|
  add_update_task(task_title, eval(action))
end

When(/^I should see task ([A-z]*) added successfully$/) do |task_title|
  check_success_add(task_title)
end

When(/^I should see task ([A-z]*) updated successfully$/) do |task_title|
  check_success_update(task_title)
end

When(/^I should see task ([A-z]*) deleted successfully$/) do |task_title|
  # find waits..
  find(:xpath, "//p[contains(text(),'#{t("tasks.destroy.success",name: task_title)}')]")
end

When(/^I add task ([A-z]*) (t.*) for (.*)$/) do |task_title, action, _|
  add_update_task(task_title, eval(action))
end

Then(/^I should see the (.*) task in position ([0-9]*) of the (.*) timeline$/) do |task_title, position, timeline|
  nodes = all(:xpath, "//div[@class='list-stages']//a/li/span")
  expect nodes[position.to_i - 1].text == task_title
end

Then(/^I should see the content of task (.*)$/) do |task_title|
  check_active(task_title)
end

Then(/^I add tasks (.*) after task (.*) for (.*) timeline$/) do |task_titles, task_title, _|
  click_on task_title

  task_titles.split(',').each do |title|
    add_update_task(title, t("tasks.show.insert_after", page: task_title))
    check_active(title)
    check_success_add(title)
    task_title = title
  end

end

Then(/^tasks (.*) to (.*) should appear in order for (.*)$/) do |first_task, last_task, _|
  task_nodes = all(:xpath, "//div[@class='list-stages']//a/li/span")
  tasks = TimelineFixture.tasks[TimelineFixture.tasks.index{ |t| t[:title] == first_task}..TimelineFixture.tasks.index{ |t| t[:title] == last_task}]
  expect task_nodes.count == tasks.count

  (0...tasks.count).each do |index|
    expect task_nodes[index].text == tasks[index][:title]
  end
end

Then(/^I update task (.*) with (.*) for (.*)$/) do |old_task, new_task, _|
  find(:xpath, "//span[text()='#{old_task}']/parent::li/parent::a").click()
  find(:xpath, "//h2[text()='#{old_task}']")
  add_update_task(new_task, t("tasks.show.edit"))
end

When(/^I delete task (.*)$/) do |task_title|
  select_task(task_title)
  click_on t("tasks.show.delete")
  find(:xpath,"//button[contains(@class,'btn-delete')]").click()
end

Then(/^tasks ([A-z]*) to ([A-z]*) should link together (.*)$/) do |first_task, last_task, response|
  select_task(first_task)
  tasks = TimelineFixture.tasks[TimelineFixture.tasks.index{ |t| t[:title] == first_task}...TimelineFixture.tasks.index{ |t| t[:title] == last_task}]

  tasks.each do |task|
    find(:xpath, "//h2[text()='#{task[:title]}']") # check loaded
    if response == "positive"
      click_on task[:positive]
    elsif response == "negative"
      find(:xpath, "//div[@id='viewAnswer']").click()
      click_on t("tasks.show.done")
    end
  end
end

When(/^I (t.*) finale (.*)$/) do |operation, content|
  click_on eval(operation)
  find(".finale_complete_message") # check loaded
  fill_in_ckeditor(:finale_complete_message, with: TimelineFixture.finale[content.to_sym][:complete_message])
  fill_in_ckeditor(:finale_incomplete_message, with: TimelineFixture.finale[content.to_sym][:incomplete_message])
  click_on t("tasks.form.submit")
end

When(/^I can see the (.*) (.*) finale in the timeline$/) do |state, content|
  find(:xpath, "//span[text()='#{state.capitalize()}']/parent::li/parent::a").click()
  find(:xpath, "//h2[text()='Finale #{state.capitalize()}']", wait: 10)# check loaded
  expect(page).to have_content(TimelineFixture.finale[content.to_sym]["#{state}_message".to_sym])
end

When(/^I have a (.*) timeline$/) do |timeline|
  TimelineFixture.create_timeline(eval(timeline), Global.root)
end

When(/^I clone the (.*) timeline$/) do |timeline|
  visit "/"
  click_on t("components.navigation.timeline")

  scope = find(:xpath, "//td/a[text()='#{eval(timeline)}']/parent::td/parent::tr")
  within scope do
    find(".clone").click
  end
end

When(/^I should see a (.*) timeline$/) do |timeline|
  expect(page).to have_content(eval(timeline))
end

When(/^I select the (.*) timeline$/) do |timeline|
  click_on eval(timeline)
  find(:xpath, "//h2[text()='#{TimelineFixture.tasks[0][:title]}']") # check loaded
end

When(/^I enable My Journey for a developer$/) do
  visit "/developers"
  click_on CreateFixture.developer_name
  find("[data-action='edit']").click()
  check :developer_timeline
  click_on t("developers.form.submit")
end

When(/^I can view developer timelines$/) do
  within ".navbar-menu" do
    click_on t("components.navigation.developers")
  end
  click_on CreateFixture.developer_name
  click_on t("developers.form.timeline")
  expect(page).to have_content "You have no timelines."
end

When(/^I can import the global (.*) timeline$/) do |timeline|
  click_on t("developers.timelines.import.title")
  select eval(timeline), visible: false
  click_on t("developers.timelines.import.import")
  find(:xpath, "//a[text()='#{eval(timeline)} (copy)']/parent::td/parent::tr")
end

When(/^I can see the developers timelines$/) do
  click_on t("components.navigation.my_developer")
  expect(page).to have_content t("developers.form.timeline")
  click_on t("developers.form.timeline")
end

When(/^I import the TimelineFixture.england timeline$/) do
  click_on t("components.navigation.my_developer")
  expect(page).to have_content t("developers.form.timeline")
  click_on t("developers.form.timeline")
end

When(/^my home is associated with the (.*) timeline$/) do |timeline|
  HomeownerUserFixture.associate_timeline(eval(timeline))
end

When(/^my home is not associated with the (.*) timeline$/) do |timeline|
  expect PlotTimeline.count == 0
end

Then(/^I cannot begin My Journey$/) do
  visit '/'
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end

  expect(page).not_to have_content t("layouts.homeowner.nav.timeline")
end


Then(/^I can begin My Journey$/) do
  visit '/'
  within ".burger-navigation" do
    check_box = find(".burger")
    check_box.trigger(:click)
  end

  expect(page).to have_content t("layouts.homeowner.nav.timeline")
  click_on t("layouts.homeowner.nav.timeline")

  # splash page
  find(".timeline-btn").click() # find waits ..
  # select stage
  find(".step-options a", match: :first).click() # find waits ..
end

Then(/^I can answer (.*) to task (.*)$/) do |answer, task_title|
  check_task(task_title, true, answer)
end

Then(/^I can answer (.*) to tasks (.*)$/) do |answer, task_titles|
  task_titles.split(',').each do |title|
    check_task(title, true, answer)
  end
end

Then(/^I should see the (.*) timeline message$/) do |message|
  find(:xpath,"//div[contains(@class,'#{message}') and @id='activeTaskScroll']")
  expect(page).to have_content TimelineFixture.finale[:content]["#{message}_message".to_sym]
end

def add_update_task(task_title, action)
  task = TimelineFixture.timeline_task(task_title)

  expect(page).to have_content(action)
  within ".btn-group" do
    click_on action
  end

  expect(page).to have_content(t("tasks.form.area_guide"))

  page.choose({id: "task_stage_id_#{task[:stage_id]}"}) if action != t("tasks.show.edit")
  %i[title question answer positive negative].each do |field|
    fill_in "task_#{field}", with: task[field]
  end

  fill_in_ckeditor(:task_response, with: task[:response])

  # Add/delete action
  addbtn = find_by_id("addActionBtn",wait: false, visible: :all)
  if addbtn.visible? &&task[:action]

    # add it
    addbtn.click()

    %i[title link].each do |field|
      fill_in "task_action_attributes_#{field}", with: task[:action][field]
    end
  elsif task[:action]
    # delete it
    find_by_id("actionInput",wait: false).click()
  end

  # Add/delete feature/action
  addbtn = find_by_id("addFeatureBtn",wait: false, visible: :all)
  if addbtn.visible? &&task[:feature]

    # add it
    addbtn.click()

    %i[title description precis link].each do |field|
      fill_in "task_features_attributes_0_#{field}", with: task[:feature][field]
    end
  elsif task[:feature]
    # delete it
    find_by_id("FeatureInput",wait: false).click()
  end

  click_on t("tasks.form.submit")
end

def check_active(task_title, homeowner = false, negative = true)
  task = TimelineFixture.timeline_task(task_title)
  expect(page).to have_content(task[:question])
  expect(page).to have_content(task[:positive])
  expect(page).to have_content(task[:negative])
  active = homeowner ?
      find(:xpath, "//li[contains(@class, 'active')]/a") :
      find(:xpath, "//li[contains(@class, 'active')]/span")
  expect active.text == task[:title]

  if negative
    homeowner ? click_on(task[:negative]) :
                find(:xpath, "//div[@id='viewAnswer']").click()

    expect(page).to have_content(parsed(task[:response]))

    if task[:action]
      expect(page).to have_content(task[:action][:title])
      find(:xpath, "//button[contains(@onclick,'#{task[:action][:link]}')]", visible: all)
    end

    if task[:feature]
      expect(page).to have_content(task[:feature][:title])
      expect(page).to have_content(parsed(task[:feature][:precis]))
      expect(page).to have_content(parsed(task[:feature][:description]))
      find(:xpath, "//button[contains(@onclick,'#{task[:feature][:link]}')]", visible: all)
    end
  end

end

def parsed(source)
  return source.dup.gsub("&lt;", "<").gsub("&gt;", ">") if $current_user.is_a? User
  Lookup.parse(source.dup, $current_user.plots[0], $current_user)
end

def check_success_add(component)
  success_flash = t("controller.success.create",name: component)
  expect(page).to have_content(success_flash)
end

def check_success_update(component)
  success_flash = t("controller.success.update",name: component)
  expect(page).to have_content(success_flash)
end

def select_task(task)
  find(:xpath, "//span[text()='#{task}']/parent::li/parent::a").click()
  find(:xpath, "//h2[text()='#{task}']")# check loaded
end

def check_task(task_title, homeowner, answer)
  task = TimelineFixture.timeline_task(task_title)

  # select task
  click_on task_title
  find(:xpath, "//li[@id='activeTaskScroll']/a[contains(text(),'#{task_title}')]", visible:all)
  check_active(task_title, homeowner, answer.downcase == "no")
  if answer.downcase == "no"
    find(:xpath, "//input[@value='#{t("tasks.show.skip")}']", visible: all).trigger('click')
  else
    click_on task[:positive]
  end
  check_status(task_title, answer.downcase == "yes") # check the status
end

def check_status(task_title, positive = true)
  find(:xpath, "//li[contains(@class,'#{positive ? :complete : :negative}')]/a[text()='#{task_title}']")
end
