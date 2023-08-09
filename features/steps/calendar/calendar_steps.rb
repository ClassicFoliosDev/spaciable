# frozen_string_literal: true
When (/^the calendar is initialised$/) do
  CalendarFixture.initialise
end

When (/^I go to the (.*) I (.*)see a calendar tab$/) do |type, expect|
  case type
  when "development"
    visit("/developers/#{CreateFixture.developer.id}/developments/#{CreateFixture.development.id}")
    find(".development .section-data") # confirm page
  when "phase"
    visit("/developments/#{CreateFixture.development.id}/phases/#{CreateFixture.phase.id}")
    find(".phase .section-data") # confirm page
  when "plot"
    visit "/plots/#{CreateFixture.phase_plot.id}"
    find(".plot .section-data") # confirm page
  end
  if expect.rstrip == "dont"
    expect(page).not_to have_content("Calendar")
  else
    expect(page).to have_content("Calendar")
  end
end

When (/^I click on the (.*) calendar tab I see a calendar$/) do |type|
  click_on "Calendar"
  find(".active i.fa-calendar")

  expect(page).to have_content(Time.zone.now.strftime("%B %Y"))
  expect(page).to have_content("Add #{type.capitalize()} Event")
  find(".fc-month-button.fc-state-active")
  expect(page).to have_css(".fc-today[data-date='#{Time.zone.now.strftime("%Y-%m-%d")}']", count: 2)
end

When (/^I can add a (.*) event using the Add Event button$/) do |type|
  click_on "Add #{type.capitalize()} Event"
  find(".ui-dialog", visible: true)

  expect(page).to have_content("Add #{type.capitalize()} Event")

  case type
    when "plot"
      page.assert_selector('.select-all-resources', visible: true, count: 0)
      page.assert_selector('.plot-status-label', visible: true, count: Resident.all.count)
      page.assert_selector('.uninvite-resource-btn', visible: true, count: Resident.all.count)
    when "phase"
      page.assert_selector('.select-all-resources', visible: true, count: 1)
      page.assert_selector('.phase-status-label', visible: true, count: Resident.all.count)
      page.assert_selector('.invite-resource-btn', visible: true, count: Resident.all.count)
    when "development"
      page.assert_selector('.resources', visible: true, count: 0)
  end

  exp = populate_event(type: type)
  click_on "Add"
  CallbackFixture.confirm {Event.last.present? && Event.last == Event.find_by(exp)}
  check_event
end

Then (/^I can update a (.*) event$/) do |type|
  open_event

  expect(page).to have_content("Edit #{type.capitalize()} Event")

  case type
    when "plot"
      page.assert_selector('.select-all-resources', visible: true, count: 0)
      page.assert_selector('.plot-status-label', visible: true, count: Resident.all.count)
      page.assert_selector('.uninvite-resource-btn', visible: true, count: Resident.all.count)
    when "phase"
    when "development"
      page.assert_selector('#dev_counts', visible: true, count: 1)
  end

  CalendarFixture.event.title = CalendarFixture::TITLES[:tomorrow]
  CalendarFixture.event.location = CalendarFixture::LOCATIONS[:erics]
  CalendarFixture.event.start = CalendarFixture.now + 24.hours + 10.minutes
  CalendarFixture.event.end = CalendarFixture.event.start + 15.minutes
  exp = populate_event
  click_on "Update"
  CallbackFixture.confirm {Event.last.present? && Event.last == Event.find_by(exp)}
  check_event
end

And (/^I can delete an event$/) do
  open_event

  within find(".ui-dialog", visible: true) do
    find(".btn.delete-btn").trigger('click')
  end

  expect(page).to have_content(t("events.edit.single.confirm"))
  click_on t("buttons.confirm_dialog.title")
  expect(page).not_to have_content(event_title())
end

Then (/^I can create a (.*) event by clicking on the calendar$/) do |type|

  # You have no idea how much of my life I wasted finding out
  # exactly how and why I had to do this!
  drag_from = find(".fc-day[data-date='#{(CalendarFixture.now).strftime('%Y-%m-%d')}']")
  target = find(".fc-day[data-date='#{(CalendarFixture.now).strftime('%Y-%m-%d')}']")
  drag_from.drag_to(target)

  expect(page).to have_content("Add #{type.capitalize()} Event")

  case type
    when "plot"
      page.assert_selector('.select-all-resources', visible: true, count: 0)
      page.assert_selector('.plot-status-label', visible: true, count: Resident.all.count)
      page.assert_selector('.uninvite-resource-btn', visible: true, count: Resident.all.count)
    when "phase"
      page.assert_selector('.select-all-resources', visible: true, count: 1)
      page.assert_selector('.phase-status-label', visible: true, count: Resident.all.count)
      page.assert_selector('.invite-resource-btn', visible: true, count: Resident.all.count)
    when "development"
      page.assert_selector('.resources', visible: true, count: 0)
  end

  CalendarFixture.event.title = "click event"
  CalendarFixture.event.location = "click location"
  CalendarFixture.event.start = nil # auto populated to 12am
  CalendarFixture.event.end = nil # auto populated to 12:15am
  exp = populate_event(type: type)
  click_on "Add"
  CallbackFixture.confirm {Event.last.present? && Event.last == Event.find_by(exp)}

  CalendarFixture.event.start = (CalendarFixture.now).change(:hour => 0)
  CalendarFixture.event.end = CalendarFixture.event.start + 15.minutes
  find_event # wait for the event to appear on the calendar

  check_event
end

When (/^I go to the (.*) calendar$/) do |type|
  case type
  when "development"
    visit("/developments/#{CreateFixture.development.id}/calendars")
  when "phase"
    visit("/phases/#{CreateFixture.phase.id}/calendars")
  when "plot"
    visit "/plots/#{CreateFixture.phase_plot.id}?active_tab=calendar"
  end
  find(".active i.fa-calendar")
end

Then (/^I can add a (.*)repeating calendar event$/) do |repeat|

  CalendarFixture.event.title = "repeating event"
  CalendarFixture.event.location = "repeating location"
  CalendarFixture.event.start = first_date_time
  CalendarFixture.event.end = CalendarFixture.event.start + 2.hours
  CalendarFixture.event.repeat = repeat.empty? ? :daily : repeat&.rstrip
  CalendarFixture.event.repeat_until = last_date_time

  create_event_for_first_day
  exp = populate_event
  click_on "Add"
  CallbackFixture.confirm {Event.last.present? && Event.last == Event.find_by(exp)}
  check_events(((last_date_time - first_date_time) / 86400).round + 1)

  # repeat until is changed by following delete/edit tests
  CalendarFixture.event.repeat_until = nil
end

Then (/^I can update and delete a single calendar event$/) do
  updating_day = 30
  repeating_event = CalendarFixture.event.dup

  # It is impossible to identify any of the repeating events by date.  The
  # calendar month view shows 6 weeks - 42 days.  So we will pick one by index
  open_event(occurance: updating_day)

  # update it
  CalendarFixture.event.title = "single updated event"
  CalendarFixture.event.location = "single updated location"
  CalendarFixture.event.start = first_date_time + updating_day.days + 1.hour
  CalendarFixture.event.end = CalendarFixture.event.start + 2.hours

  exp = populate_event
  click_on "Update"
  click_on "Confirm" # default 'this event only'
  CallbackFixture.confirm {Event.last.present? && Event.last == Event.find_by(exp)}
  check_event

  #delete it
  prev_num_events = Event.all.count

  open_event
  within find(".ui-dialog", visible: true) do
    find(".btn.delete-btn").trigger('click')
  end

  event_id = find("#event_id", visible: false).value.to_i
  CallbackFixture.confirm {Event.find_by(id: event_id).present?}
  click_on "Confirm" # default 'this event only'
  CallbackFixture.confirm {Event.find_by(id: event_id).blank?}

  num_events = Event.all.count
  expect(num_events).to eq(prev_num_events - 1)

  # go back to the repeating event details
  CalendarFixture.event = repeating_event

  # check the visible event count
  expect(events.count).to eq(num_events)
end

Then (/^I can update and delete this and following calendar events$/) do

  updating_day = 20
  repeating_event = CalendarFixture.event.dup

  # It is impossible to identify any of the repeating events by date.  The
  # calendar month view shows 6 weeks - 42 days.  So we will pick one by index
  open_event(occurance: updating_day)

  # update it
  CalendarFixture.event.title = "this and following updated event"
  CalendarFixture.event.location = "this and following updated location"
  CalendarFixture.event.start = first_date_time + updating_day.days + 20.minutes
  CalendarFixture.event.end = CalendarFixture.event.start + 30.minutes

  exp = populate_event
  click_on "Update"
  page.choose("this_and_following")
  click_on "Confirm" # this and following
  CallbackFixture.confirm {Event.last.present? && Event.last == Event.find_by(exp)}

  expect(events.count).to eq(CalendarFixture::MONTHVIEWDAYS - updating_day)

  # this and following creates a new sequence
  deleteoccurance = 2
  open_event(occurance: deleteoccurance) # delete 3rd occurance of this new repeating event
  event_id = find("#event_id", visible: false).value.to_i
  within find(".ui-dialog", visible: true) do
    find(".btn.delete-btn").trigger('click')
  end
  page.choose("this_and_following")
  click_on "Confirm" # default 'this and following'
  CallbackFixture.confirm {Event.all.order(:id).last.id == (event_id-1)}
  # check only 2 left
  expect(events.count).to eq(deleteoccurance)

    # go back to the repeating event details
  CalendarFixture.event = repeating_event
end

Then (/^I can update and delete all events$/) do

  updating_day = 10
  repeating_event = CalendarFixture.event.dup

  # It is impossible to identify any of the repeating events by date.  The
  # calendar month view shows 6 weeks - 42 days.  So we will pick one by index
  open_event(occurance: updating_day)

  num_events = Event.where(title: CalendarFixture.event.title).count

  # update it
  CalendarFixture.event.title = "all updated event"
  CalendarFixture.event.location = "all updated location"
  CalendarFixture.event.start = first_date_time + updating_day.days + 10.minutes
  CalendarFixture.event.end = CalendarFixture.event.start + 20.minutes

  exp = populate_event
  click_on "Update"
  page.choose("all_events")
  click_on "Confirm" # all events
  CallbackFixture.confirm {Event.last.present? && Event.last == Event.find_by(exp)}

  expect(events.count).to eq(num_events)

  # this and following creates a new sequence
  deleteoccurance = 2
  # choose any repeat in the sequence.  'all events' will delete them all
  open_event(occurance: deleteoccurance)
  within find(".ui-dialog", visible: true) do
    find(".btn.delete-btn").trigger('click')
  end
  page.choose("all_events")
  click_on "Confirm" # all events
  CallbackFixture.confirm {Event.where(title: CalendarFixture.event.title).count.zero?}
  # check all gone
  expect(events.count).to eq(0)

    # go back to the repeating event details
  CalendarFixture.event = repeating_event
end

Then (/^I can update to (.*) repeating$/) do |repeat|

  open_event(occurance: events.count-1) # open the last event
  repeater = Event.new(repeat: (repeat.empty? ? :daily : repeat&.rstrip))

  exp = populate_event(repeater)
  click_on "Update"
  page.choose("all_events")
  click_on "Confirm" # all events
  CallbackFixture.confirm {Event.last.present? && Event.last == Event.find_by(exp)}

  expect(events.count).to eq((CalendarFixture::MONTHVIEWDAYS.days / CalendarFixture.event.repeat_interval(repeat).to_f).ceil)
end

Then (/^I can add a (.*) event and invite the resident$/) do |type|
  click_on "Add #{type.capitalize()} Event"
  find(".ui-dialog", visible: true)

  populate_event(type: type)

  click_on "Add"
  check_event
end

Then (/^I can see an (invite|accept|decline) on my (.*) calendar$/) do |status, type|
  goto_resident_calendar
  check_homeowner_event(status: status, type: type)
end

Then (/^I cannot renegotiate the event time$/) do
  expect(page).not_to have_content("Change")
end

Then (/^I can (accept|decline) the (.*) event$/) do |status, type|
  open_event
  event_id = find("#event_id", visible: false).value.to_i
  find("##{status}_event").trigger('click')
  CallbackFixture.confirm {EventResource.find_by(event_id: event_id, status: (status == "accept" ? "accepted" : "declined")).present?}
  open_event
  check_homeowner_event(status: status, type: type)
end

Then (/^I can propose an amendment to the date and time$/) do
  open_event
  find("#change_event").trigger('click')

  repropose = Event.new(start: CalendarFixture.reproposed_start,
                        end: CalendarFixture.reproposed_end)

  exp = populate_event(repropose)
  click_on "Save"
  CallbackFixture.confirm {Event.last.present? && Event.last == Event.find_by(exp)}

  open_event
  check_homeowner_event(status: "change")
end

Then (/^I can accept the rescheduled date and time$/) do
  open_event
  event_id = find("#event_id", visible: false).value.to_i

  within find(".ui-dialog", visible: true) do
    expect(page).to have_content(tz(CalendarFixture.reproposed_start).strftime("%d-%m-%Y").strip)
    expect(page).to have_content(tz(CalendarFixture.reproposed_start).strftime("%l:%M").strip)
    expect(page).to have_content(tz(CalendarFixture.reproposed_end).strftime("%d-%m-%Y").strip)
    expect(page).to have_content(tz(CalendarFixture.reproposed_end).strftime("%l:%M").strip)
    expect(page).to have_content(t("events.accept_proposal"))
    expect(page).to have_content("Proposed Reschedule")
  end

  find("#accept_reschedule").trigger('click')
  find(".proposed_datetime", visible: false).visible?
  expect(find(:xpath, "//label[contains(@class, 'resource-label')][contains(@for,'event_resources_#{CreateFixture.resident.id}')]//parent::td//parent::tr")['class']).to eq("invited")

  click_on "Update"
  CallbackFixture.confirm {EventResource.find_by(event_id: event_id, status: "invited").present?}

  CalendarFixture.event.start = CalendarFixture.reproposed_start
  CalendarFixture.event.end = CalendarFixture.reproposed_end
  check_event
end

Then (/^I can see the event has been (.*)$/) do |status|
  within find_event do
    find(".#{status}")
  end
end

Then (/^I can see the (.*) event has been (.*)$/) do |type, status|
  open_event

  find(".ui-dialog-titlebar")
  expect(page).to have_content("Edit #{type.capitalize()} Event")

  case type
  when "development"
    case status
    when "accepted"
      expect(find(".dev_accepted p").text()).to eq("1")
      expect(find(".dev_declined p").text()).to eq("0")
      page.assert_selector('label.accepted', visible: true, count: 1)
    when "declined"
      expect(find(".dev_accepted p").text()).to eq("0")
      expect(find(".dev_declined p").text()).to eq("1")
      page.assert_selector('label.declined', visible: true, count: 1)
    end
  when "phase"
    page.assert_selector('.uninvite-resource-btn', visible: true, count: 1)
    case status
    when "accepted"
      page.assert_selector('label.accepted', visible: true, count: 1)
    when "declined"
      page.assert_selector('label.declined', visible: true, count: 1)
    end
  end

  click_on "Cancel"
end

Then (/^I can view but not update the rescheduled event$/) do
  open_event

  expect(page).not_to have_content("Update")
  expect(find("#event_title").disabled?).to eq(true)
  expect(find("#event_location").disabled?).to eq(true)
  expect(find("#event_repeat-button").disabled?).to eq(true)
  expect(find(:xpath, "//input[@id='event_start_date']/following-sibling::input", visible: false).disabled?).to eq(true)
  expect(find(:xpath, "//input[@id='event_start_time']/following-sibling::input", visible: false).disabled?).to eq(true)
  expect(find(:xpath, "//input[@id='event_end_time']/following-sibling::input", visible: false).disabled?).to eq(true)
  expect(find(:xpath, "//input[@id='event_end_time']/following-sibling::input", visible: false).disabled?).to eq(true)

  expect(page).to have_content("Proposed Reschedule")

  click_on "Cancel"
end

Then (/^I cannot see a calendar$/) do
  visit "/"
  find(".burger-bar.bar-middle").trigger('click')
  expect(page).not_to have_content(t("components.homeowner.navigation.calendar"))
end

And (/^the calendar is disabled for the development$/) do
  CreateFixture.development().update_attributes(calendar: false)
end

def populate_event(event = CalendarFixture.event, type: nil)
  exp = {}

  within find(".ui-dialog", visible: true) do
    if event.title
      fill_in :event_title, with: event.title
      exp[:title] = event.title
    end
    if event.location
      fill_in :event_location, with: event.location
      exp[:location] = event.location
    end
  end

  if type == "phase"
    find('.select-all-resources').trigger('click')
  end

  setDateTime('start', event) if event.start
  exp[:start] = event.start
  setDateTime('end', event) if event.end
  exp[:end] = event.end

  if event.repeat
    select t("events.repeat.#{event.repeat}"), :from => "event_repeat", visible: false
    exp[:repeat] = event.repeat
  end
  if event.reminder
    select t("events.remind.#{event.reminder}"), :from => "event_reminder", visible: false
    exp[:reminder] = event.reminder
  end

  setRepeatUntil
  exp[:repeat_until] = event.repeat_until

  exp
end

def setDateTime(field, event = CalendarFixture.event)
  if event.send(field)
    dt = event.send(field).utc.strftime("%Y-%m-%dT%H:%M:00.000Z")
    find("#event_#{field}_date", visible:false).set(dt)
    find("#event_#{field}_time", visible:false).set(dt)
  end
end

def setRepeatUntil(event = CalendarFixture.event)
  return unless event.repeat_until

  find(:xpath, "//input[@id='event_repeat_until']/following-sibling::node()", visible: false).trigger('focus')
  within ".flatpickr-calendar.open" do
    find(".flatpickr-day[aria-label='#{tz(event.repeat_until).strftime('%B %-d, %Y')}']").trigger('mouseover')
    find(".flatpickr-day[aria-label='#{tz(event.repeat_until).strftime('%B %-d, %Y')}']").trigger('mousedown')
  end
end

def check_event(e = CalendarFixture.event, occurance: 0)
  open_event(e, occurance: occurance)

  expect(find('#event_title').value).to eql(e.title) if e.title
  expect(find('#event_location').value).to eql(e.location) if e.location
  expect(find('#event_repeat-button').text).to eql(t("events.repeat.#{e.repeat}")) if e.repeat
  expect(find('#event_reminder-button').text).to eql(t("events.remind.#{e.reminder}")) if e.reminder
  check_datetimes(e)

  click_on "Cancel"
end

def check_homeowner_event(e = CalendarFixture.event, status: "invite", type: "plot")
  open_event(e)

  expect(find('#event_title').value).to eql(e.title) if e.title
  expect(find('#event_location').value).to eql(e.location) if e.location
  check_datetimes(e)

  within find(".event_details_form", visible: false) do
    if status == "invite"
      expect(find("#accept_event", visible: false).visible?).to eq(true)
      expect(find("#decline_event", visible: false).visible?).to eq(true)
      expect(find("#change_event", visible: false).visible?).to eq(type == "plot")
    elsif status == "accept"
      expect(find("#accept_event", visible: false).visible?).to eq(false)
      expect(find("#decline_event", visible: false).visible?).to eq(true)
      expect(find("#change_event", visible: false).visible?).to eq(type == "plot")
    elsif status == "decline" || status == "change"
      expect(find("#accept_event", visible: false).visible?).to eq(false)
      expect(find("#decline_event", visible: false).visible?).to eq(false)
      if status == "change"
        expect(find("#change_event", visible: false).visible?).to eq(false)
      else
        expect(find("#change_event", visible: false).visible?).to eq(type == "plot")
      end
    end
  end

  click_on "Cancel"
end

# This is to find a single event.  A 'find' will wait and
# can be used to confirm that an event update has appeared
# on the calendar after an update
def event(e = CalendarFixture.event)
  find(:xpath, "//a[contains(@class,'fc-day-grid-event') and "\
                   "contains(.,'#{tz(e.start).strftime('%-k:%M').lstrip}') and " \
                   "contains(.,'#{e.title.lstrip}')]")
end

# Repeats result in multiple hits
def events(e = CalendarFixture.event)
  all(:xpath, "//a[contains(@class,'fc-day-grid-event') and "\
                  "contains(.,'#{tz(e.start).strftime('%-k:%M').lstrip}') and " \
                  "contains(.,'#{e.title.lstrip}')]")
end

def open_event(e = CalendarFixture.event, occurance: 0)
  find_event(e,  occurance: occurance).trigger('click')
  find("#event_title", visible: true) # ensure dialog open
end

def find_event(e = CalendarFixture.event, occurance: 0)
  occurance.zero? ? event(e) : events(e)[occurance]
end

def check_events(occurances, e = CalendarFixture.event)
  expect(events().count).to eq(occurances)
end

def event_title(e = CalendarFixture.event)
  "#{tz(e.start).strftime('%-k:%M').lstrip} #{e.title}".lstrip
end

def tz(time)
  time.in_time_zone(CalendarFixture.timezone)
end

def tz2(time)
  time.in_time_zone(CalendarFixture.timezone)
end

# FullCalendar does not play well with webkit at all.  FullCalendar
# does all sorts of weirdness hiding fields and creating copies and
# webkit seems unable to keep track. So we have to compare the dates and times
# with the values in the hidden fields
def check_datetimes(event = CalendarFixture.event)
  return unless event.start && event.end

  timezone = CalendarFixture.timezone

  # start date and time both should hold an identical date/time
  # they just display as a date or a time to the user.  Remember to
  # ensure all in the correct timezone as calendar displays in
  # 'local' time
  start = event.start
  expect(tz(start)).to eql(tz2(Time.parse(find('#event_start_date', visible:false).value)))
  expect(tz(start)).to eql(tz2(Time.parse(find('#event_start_time', visible:false).value)))

  finish = event.end
  expect(tz(finish)).to eql(tz2(Time.parse(find('#event_end_date', visible:false).value)))
  expect(tz(finish)).to eql(tz2(Time.parse(find('#event_end_time', visible:false).value)))
end

# Create an event in the first day on the calendar.  This allows us to know
# we can create repeats that will definately appear in the current calendar view
def create_event_for_first_day
  #calendar_days = all(:xpath, "//td[contains(@class,'fc-day')]")
  calendar_days[1].drag_to(calendar_days.first)
end

# Get a Time (inc date) for the first day on the calendar
def first_date_time(time = "13:30")
  tz(Time.strptime(calendar_days.first['data-date'] + " " + time,"%Y-%m-%d %H:%M"))
end

# Get a Time (inc date) for the last day on the calendar
def last_date_time(time = "13:30")
  tz(Time.strptime(calendar_days.last['data-date'] + " " + time,"%Y-%m-%d %H:%M"))
end

def calendar_days
  all(:xpath, "//td[contains(@class,'fc-day')]")
end

def goto_resident_calendar
  visit "/"
  find(".burger-bar.bar-middle").trigger('click')
  click_on t("components.homeowner.navigation.calendar")
end
