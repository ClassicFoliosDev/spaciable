
When(/^there are diverse developments with plots and residents$/) do
  VisitsFixture.create_residents
end

When(/^I log in as resident (.*)$/) do |resident|
  login_as VisitsFixture.send("resident#{resident}")
end

When(/^I log in as CF admin$/) do
  cf_admin = FactoryGirl.create(:cf_admin, email: ExpiryFixture.cf_email, password: ExpiryFixture.cf_password)
  login_as cf_admin
end

Then(/^I navigate through the homeowner site$/) do

  # tag each vist with the data that can be filtered
  plot = RequestStore.store[:current_user].plots.first
  meta = {
           developer_id: plot.developer_id,
           development_id: plot.development_id,
           user_id: RequestStore.store[:current_user].id,
           business: plot.phase.business,
           date_range: rand(0..1)
         }

  # vists dashboard twice
  (1..rand(1..2)).each do |i|
    visit "/dashboard"
    VisitsFixture.visited(meta, :view_main_menu)
  end

  (1..rand(1..2)).each do |i|
    referafriend
    VisitsFixture.visited(meta, :refer_a_friend)
  end

  (1..rand(1..2)).each do |i|
    visit "/homeowners/my_home"
    VisitsFixture.visited(meta, :view_home_tour)
    VisitsFixture.visited(meta, :view_my_home)
  end

  (1..rand(1..2)).each do |i|
    visit "homeowners/private_documents"
    VisitsFixture.visited(meta, :view_library, "My Documents")

    Document.pluck(:category).uniq.each do |category|
      visit "/homeowners/library/#{category}"
      VisitsFixture.visited(meta, :view_library,
                            t("activerecord.attributes.document.categories.#{category}",construction: "Home"))
    end
  end

  (1..rand(1..2)).each do |i|
    visit "/homeowners/residents/#{RequestStore.store[:current_user].id}"
    VisitsFixture.visited(meta, :view_account)

    visit "/homeowners/notifications"
    VisitsFixture.visited(meta, :view_messages)

    visit "/homeowners/area_guide"
    VisitsFixture.visited(meta, :view_area_guide)
  end

  (1..rand(1..2)).each do |i|
    visit "/homeowners/home_designer"
    VisitsFixture.visited(meta, :view_home_designer)

    visit "/homeowners/rooms"
    VisitsFixture.visited(meta, :view_rooms)

    visit "/homeowners/my_appliances"
    VisitsFixture.visited(meta, :view_appliances)
  end

  (1..rand(1..2)).each do |i|
    MyHomeFaqsFixture.faqs.each do |faq|
      next unless faq[:type] == FaqsFixture.homeowner

      visit "/homeowners/faqs/#{faq[:type].id}/#{faq[:category].id}"
      VisitsFixture.visited(meta, :view_FAQs, faq[:category].name)

      find(:xpath,"//dt/h3[contains(text(),'#{faq[:question]}')]/parent::dt").trigger('click')

      if rand(2) == 0
       find(:xpath, "//button[contains(text(),'Yes')]", visible: true).trigger('click')
       VisitsFixture.visited(meta, :view_FAQs_feedback, faq[:question], "Yes")
      else
        find(:xpath, "//button[contains(text(),'No')]", visible: true).trigger('click')
        find('.faq-input', visible: true).native.send_keys("just because it doesn't")
        click_on "Submit"
        VisitsFixture.visited(meta, :view_FAQs_feedback, faq[:question], "No")
      end
    end
  end

  (1..rand(1..2)).each do |i|
    HowTo.where(hide: false).each do |how_to|
      visit "homeowners/how_tos/category/#{how_to.category}"
      VisitsFixture.visited(meta, :view_how_to, how_to.category, I18n.t("ahoy.#{Ahoy::Event::ROOT}"))

      visit "homeowners/how_tos/#{how_to.id}"
      VisitsFixture.visited(meta, :view_how_to, how_to.category, how_to.title)
    end
  end

  (1..rand(1..2)).each do |i|
    Contact.categories.each do |name,_|
      visit "/homeowners/contacts/#{name}"
      VisitsFixture.visited(meta, :view_contacts, name)
    end
  end

  (1..rand(1..2)).each do |i|
    visit "/homeowners/home_tour"
    VisitsFixture.visited(meta, :view_home_tour)

    # ---------- Snags -----------
    visit "/homeowners/snags"
    find(".new-snag")
    click_on I18n.t("homeowners.snags.index.add_snag")
    fill_in :snag_title, with: "Snag#{RequestStore.store[:current_user].id}#{i}"
    fill_in :snag_description, with: "Snag#{i} description"
    click_on "Submit"
    VisitsFixture.visited(meta, :view_snagging, I18n.t("ahoy.#{Ahoy::Event::SNAGS_CREATED}"))

    Snag.find_by(title: "Snag#{RequestStore.store[:current_user].id}#{i}").update_attribute(:status, "awaiting")
    visit "/homeowners/snags/#{Snag.last.id}"
    find(".reject-btn")

    if rand(2) == 0
     click_on I18n.t("homeowners.snags.show.resident_approved")
     VisitsFixture.visited(meta, :view_snagging, I18n.t("ahoy.#{Ahoy::Event::SNAGS_RESOLVED}"))
    else
      click_on I18n.t("homeowners.snags.show.resident_rejected")
      VisitsFixture.visited(meta, :view_snagging, I18n.t("ahoy.#{Ahoy::Event::SNAGS_REJECTED}"))
    end
  end

  # ---------- Timelines ------------
  visit "/homeowners/timeline"
  VisitsFixture.visited(meta, :view_your_journey, "Splash")

  click_on t("homeowners.timeline.splash.continue")
  VisitsFixture.visited(meta, :view_your_journey, "Select Stage")

  click_on "Reservation"
  tasks = Task.where(timeline_id: Timeline.first.id).order(:id)
  find(:xpath, "//div[@class='question-content']/div/p[contains(text(),'#{tasks.first.question}')]")

  VisitsFixture.visited(meta, :view_your_journey, tasks.first.title,
                        I18n.t("ahoy.#{Ahoy::Event::TASK_VIEWED}"))

  click_on tasks.first.negative
  click_on "Skip"
  VisitsFixture.visited(meta, :view_your_journey, tasks.first.title, "negative")

  (1..(tasks.count-1)).each do |task|
    find(:xpath, "//div[@class='question-content']/div/p[contains(text(),'#{tasks[task].question}')]")
    VisitsFixture.visited(meta, :view_your_journey, tasks[task].title,
                        I18n.t("ahoy.#{Ahoy::Event::TASK_VIEWED}"))
    click_on tasks[task].positive
    VisitsFixture.visited(meta, :view_your_journey, tasks[task].title, "positive")
  end

  VisitsFixture.visited(meta, :view_your_journey, I18n.t("homeowners.timeline.done"))

  # update all event dates for plot to be -2 weeks if they are in date_range 1
  if meta[:date_range] == 1
    Ahoy::Event.where(plot_id: plot.id).update_all(time: Time.zone.now - 2.weeks)
    Plot.find(plot.id).update_attribute(:created_at, Time.zone.now - 2.weeks)
  end

end

When(/^I can access the page visits report$/) do
  visit '/'
  click_on t("components.navigation.analytics")
  analytics = t("admin.analytics.show.visits_btn")
  find(:xpath, "//a[contains(text(),'#{analytics}')]").trigger('click')
  find("#report")
end

Then(/^I can see the visits made$/) do
  find(:xpath,"//input[@id='reload_check'][@value='Clean']")
  check_visits(VisitsFixture.expected)
end

Then(/^I can filter by developer (developer\d)$/) do |developer|
  # The page has a test button that changes text from 'Clean' to
  # 'Dirty' when pressed. This allows the tests to check when the
  #  page has been refreshed (i.e. Press the 'Clean' button (goes 'Dirty') then
  # make the change that refreshed the page and wait for 'Clean' to reappear
  click_on 'Clean'
  select_from_selectmenu :visits_developer_id, with: VisitsFixture.send(developer + "_name")
  find(:xpath,"//input[@id='reload_check'][@value='Clean']")
  check_visits(VisitsFixture.expected, filter: {developer_id: VisitsFixture.send(developer).id})
end

Then(/^I can filter by developer (developer\d) development (.*)$/) do |developer, development|
  click_on 'Clean'
  select_from_selectmenu :visits_development_id, with: VisitsFixture.send(development + "_name")
  find(:xpath,"//input[@id='reload_check'][@value='Clean']")
  check_visits(VisitsFixture.expected,
               filter: {developer_id: VisitsFixture.send(developer).id,
                        development_id: VisitsFixture.send(development).id})
end

Then(/^I can filter by business (.*)$/) do |business|
  click_on 'Clean'
  select_from_selectmenu :visits_developer_id, with: "All"
  find(:xpath,"//input[@id='reload_check'][@value='Clean']")
  click_on 'Clean'
  select_from_selectmenu :visits_business, with: t("activerecord.attributes.phase.businesses.#{business}")
  find(:xpath,"//input[@id='reload_check'][@value='Clean']")
  check_visits(VisitsFixture.expected, filter: {business: business})
end

Then(/^I can filter by date$/) do
  click_on 'Clean'
  select_from_selectmenu :visits_business, with: "All"
  find(:xpath,"//input[@id='reload_check'][@value='Clean']")
  click_on 'Clean'
  fill_in :visits_end_date, with: (Time.zone.now - 1.week).strftime("%Y-%m-%d")
  find(:xpath,"//input[@id='reload_check'][@value='Clean']")
  sleep 2

  check_visits(VisitsFixture.expected, filter: {date_range: 1})
end

Then(/^I can generate a report$/) do
  ActionMailer::Base.deliveries.clear
  click_on t("admin.visits.show.report_btn")
  sleep 3
  email = ActionMailer::Base.deliveries.first
  expect(email).to have_body_text("report")
  expect(email.to).to eq [ExpiryFixture.cf_email]
end


# This is a recursive function that goes through the @expected structure
# calculating counts using the filters against the registered expected values
def check_visits(expected, filter: nil, level: 1)
  return if expected.empty?
  expected.each do |id,stats|
    filtered_visits = filter_visits(stats[:visits], filter)
    next if level > 1 && filtered_visits.count == 0

    within "##{id}" do
      expect(find("#t").text.to_i).to eql filtered_visits.count
      expect(find("#u").text.to_i).to eql unique_visits(filtered_visits)
    end
    check_visits(stats.except(*(stats.keys.select { |k| k.is_a? Symbol })), filter: filter, level: level+1)
  end
end

# The 'stats' are an array of registered 'meta' (see above tests) data
# that gives details for every expected event.  This meta data can be
# filtered to count the numbers differently .ie if only 'Developer1'
# events should be seen etc
def filter_visits(stats, filter)
  return stats unless filter
  fstats = stats.dup
  # apply the filters
  filter.each { |k,v| fstats.select! { |s| s[k] == v } }
  fstats
end

def unique_visits(stats)
  stats.map { |v| v[:user_id] }.uniq.count
end
