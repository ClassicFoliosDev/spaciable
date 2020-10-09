# frozen_string_literal: true
When (/^the calendar is initialised$/) do
  CalendarFixture.initialise
end

When (/^I go to the calendar plot I (.*)see a calendar tab$/) do |expect|
  visit "/plots/#{CreateFixture.phase_plot.id}"
  find(".plot .section-data") # confirm page
  if expect.rstrip == "dont"
    expect(page).not_to have_content(t("plots.collection.calendar"))
  else
    expect(page).to have_content(t("plots.collection.calendar"))
  end
end

When (/^I click on the calendar tab I see a calendar$/) do
  click_on t("plots.collection.calendar")
  find(".active i.fa-calendar")

  expect(page).to have_content(Time.zone.now.strftime("%B %Y"))
  expect(page).to have_content("Add Event")
  find(".fc-month-button.fc-state-active")
  expect(page).to have_css(".fc-today[data-date='#{Time.zone.now.strftime("%Y-%m-%d")}']", count: 2)
end

When (/^I can add a calendar event using the Add Event button$/) do
  click_on "Add Event"
  find(".ui-dialog", visible: true)

  populate_event
  click_on "Add"
  sleep 4
  check_event
end

Then (/^I can update a calendar event$/) do
  open_event

  CalendarFixture.event.title = CalendarFixture::TITLES[:tomorrow]
  CalendarFixture.event.location = CalendarFixture::LOCATIONS[:erics]
  CalendarFixture.event.start = CalendarFixture.now + 24.hours + 10.minutes
  CalendarFixture.event.end = CalendarFixture.event.start + 15.minutes
  populate_event
  click_on "Update"
  sleep 4
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

Then (/^I can create an event by clicking on the calendar$/) do

  # You have no idea how much of my life I wasted finding out
  # exactly how and why I had to do this!
  drag_from = find(".fc-day[data-date='#{(CalendarFixture.now).strftime('%Y-%m-%d')}']")
  target = find(".fc-day[data-date='#{(CalendarFixture.now-24.hours).strftime('%Y-%m-%d')}']")
  drag_from.drag_to(target)

  CalendarFixture.event.title = "click event"
  CalendarFixture.event.location = "click location"
  CalendarFixture.event.start = nil # auto populated to 12am
  CalendarFixture.event.end = nil # auto populated to 12:15am
  populate_event
  click_on "Add"
  sleep 4

  CalendarFixture.event.start = (CalendarFixture.now-24.hours).change(:hour => 0)
  CalendarFixture.event.end = CalendarFixture.event.start + 15.minutes
  find_event # wait for the event to appear on the calendar

  check_event
end

When (/^I go to the plot calendar$/) do
  visit "/plots/#{CreateFixture.phase_plot.id}?active_tab=calendar"
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
  populate_event
  click_on "Add"
  sleep 4
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

  populate_event
  click_on "Update"
  click_on "Confirm" # default 'this event only'
  check_event

  #delete it
  prev_num_events = Event.all.count

  open_event
  within find(".ui-dialog", visible: true) do
    find(".btn.delete-btn").trigger('click')
  end
  click_on "Confirm" # default 'this event only'
  sleep 4

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

  populate_event
  click_on "Update"
  page.choose("this_and_following")
  click_on "Confirm" # this and following
  sleep 4
  expect(events.count).to eq(CalendarFixture::MONTHVIEWDAYS - updating_day)

  # this and following creates a new sequence
  deleteoccurance = 2
  open_event(occurance: deleteoccurance) # delete 3rd occurance of this new repeating event
  within find(".ui-dialog", visible: true) do
    find(".btn.delete-btn").trigger('click')
  end
  page.choose("this_and_following")
  click_on "Confirm" # default 'this event only'
  sleep 4
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

  populate_event
  click_on "Update"
  page.choose("all_events")
  click_on "Confirm" # all events
  sleep 4

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
  sleep 4
  # check all gone
  expect(events.count).to eq(0)

    # go back to the repeating event details
  CalendarFixture.event = repeating_event
end

Then (/^I can update to (.*) repeating$/) do |repeat|

  open_event(occurance: events.count-1) # open the last event
  repeater = Event.new(repeat: (repeat.empty? ? :daily : repeat&.rstrip))

  populate_event(repeater)
  click_on "Update"
  page.choose("all_events")
  click_on "Confirm" # all events
  sleep 4

  expect(events.count).to eq((CalendarFixture::MONTHVIEWDAYS.days / CalendarFixture.event.repeat_interval(repeat).to_f).ceil)
end

Then (/^I can add a calendar event and invite the resident$/) do
  click_on "Add Event"
  find(".ui-dialog", visible: true)

  populate_event
  within find(:xpath, "//label[contains(@class, 'resident-label')][contains(@for,'event_residents_#{CreateFixture.resident.id}')]//parent::span") do
    find(".invite-resident-btn").trigger('click')
  end

  click_on "Add"
  check_event
end

Then (/^I can see an (.*) on my calendar$/) do |status|
  goto_resident_calendar
  check_homeowner_event(status: status)
end

Then (/^I can (.*) the event$/) do |status|
  open_event
  find("##{status}_event").trigger('click')
  sleep 4
  open_event
  check_homeowner_event(status: status)
end

Then (/^I can propose an amendment to the date and time$/) do
  open_event
  find("#change_event").trigger('click')

  repropose = Event.new(start: CalendarFixture.reproposed_start,
                        end: CalendarFixture.reproposed_end)

  populate_event(repropose)
  click_on "Save"
  sleep 4
  open_event
  check_homeowner_event(status: "change")
end

Then (/^I can accept the reproposed date and time$/) do
  open_event
  find(".view-proposed-datetime").trigger('click')

  within find(".ui-dialog", visible: true) do
    expect(page).to have_content(tz(CalendarFixture.reproposed_start).strftime("%d-%m-%Y"))
    expect(page).to have_content(tz(CalendarFixture.reproposed_start).strftime("%l:%M"))
    expect(page).to have_content(tz(CalendarFixture.reproposed_end).strftime("%d-%m-%Y"))
    expect(page).to have_content(tz(CalendarFixture.reproposed_end).strftime("%l:%M"))
    expect(page).to have_content(t("events.accept_proposal"))
    expect(page).to have_content("Proposed Rescheduling")
  end

  find("#accept_reschedule").trigger('click')
  find(".proposed_datetime", visible: all).visible?
  expect(find(:xpath, "//label[contains(@class, 'resident-label')][contains(@for,'event_residents_#{CreateFixture.resident.id}')]//parent::span")['class']).to eq("checked invited")

  click_on "Update"
  sleep 4

  CalendarFixture.event.start = CalendarFixture.reproposed_start
  CalendarFixture.event.end = CalendarFixture.reproposed_end
  check_event

end

Then (/^I can see the event has been (.*)$/) do |status|
  within find_event do
    find(".circle.fill-#{status}")
  end
end

Then (/^I can view but not update the reproposed event$/) do
  open_event

  expect(page).not_to have_content("Update")
  expect(find("#event_title").disabled?).to eq(true)
  expect(find("#event_location").disabled?).to eq(true)
  expect(find("#event_repeat-button").disabled?).to eq(true)
  expect(find(:xpath, "//input[@id='event_start_date']/following-sibling::input", visible: all).disabled?).to eq(true)
  expect(find(:xpath, "//input[@id='event_start_time']/following-sibling::input", visible: all).disabled?).to eq(true)
  expect(find(:xpath, "//input[@id='event_end_time']/following-sibling::input", visible: all).disabled?).to eq(true)
  expect(find(:xpath, "//input[@id='event_end_time']/following-sibling::input", visible: all).disabled?).to eq(true)

  find(".view-proposed-datetime").trigger('click')
  expect(page).to have_content("Proposed Rescheduling")

  click_on "Cancel"
end

Then (/^I cannot see a calendar$/) do
  visit "/"
  find(".burger-bar.bar-middle").trigger('click')
  expect(page).not_to have_content(t("components.homeowner.navigation.calendar"))
end

def populate_event(event = CalendarFixture.event)
  within find(".ui-dialog", visible: true) do
    fill_in :event_title, with: event.title if event.title
    fill_in :event_location, with: event.location if event.location
  end

  setDateTime('start', event) if event.start
  setDateTime('end', event) if event.end

  select t("events.repeat.#{event.repeat}"), :from => "event_repeat", visible: false if event.repeat
  select t("events.remind.#{event.reminder}"), :from => "event_reminder", visible: false if event.reminder

  setRepeatUntil
end

def setDateTime(field, event = CalendarFixture.event)
  if event.send(field)
    # set the date
    find(:xpath, "//input[@id='event_#{field}_date']/following-sibling::node()", visible: all).trigger('focus')
    within ".flatpickr-calendar.open" do
      find(".flatpickr-day[aria-label='#{tz(event.send(field)).strftime('%B %-d, %Y')}']").trigger('mouseover')
      find(".flatpickr-day[aria-label='#{tz(event.send(field)).strftime('%B %-d, %Y')}']").trigger('mousedown')
    end
    # and time
    find(:xpath, "//input[@id='event_#{field}_time']/following-sibling::input", visible: all).trigger('focus')
    within ".flatpickr-calendar.open" do
      find('.numInput.flatpickr-hour').set(tz(event.send(field)).strftime('%-l'))
      find('.numInput.flatpickr-minute').set(tz(event.send(field)).strftime('%M'))
      am_pm = tz(event.send(field)).strftime('%p')
      am_pm_picker = find('.flatpickr-am-pm')
      if am_pm != am_pm_picker.text
        am_pm_picker.trigger('mouseover')
        am_pm_picker.trigger('mousedown')
      end
      find('.numInput.flatpickr-minute').native.send_keys(:return)
    end
  end
end

def setRepeatUntil(event = CalendarFixture.event)
  return unless event.repeat_until

  find(:xpath, "//input[@id='event_repeat_until']/following-sibling::node()", visible: all).trigger('focus')
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

def check_homeowner_event(e = CalendarFixture.event, status: "invite")
  open_event(e)

  expect(find('#event_title').value).to eql(e.title) if e.title
  expect(find('#event_location').value).to eql(e.location) if e.location
  check_datetimes(e)

  within find(".event_details_form", visible: all) do
    if status == "invite"
      expect(find("#accept_event", visible: all).visible?).to eq(true)
      expect(find("#decline_event", visible: all).visible?).to eq(true)
      expect(find("#change_event", visible: all).visible?).to eq(true)
    elsif status == "accept"
      expect(find("#accept_event", visible: all).visible?).to eq(false)
      expect(find("#decline_event", visible: all).visible?).to eq(true)
      expect(find("#change_event", visible: all).visible?).to eq(true)
    elsif status == "decline" || status == "change"
      expect(find("#accept_event", visible: all).visible?).to eq(false)
      expect(find("#decline_event", visible: all).visible?).to eq(false)
      expect(find("#change_event", visible: all).visible?).to eq(true)
    end
  end

  click_on "Cancel"
end

# This is to find a single event.  A 'find' will wait and
# can be used to confirm that an event update has appeared
# on the calendar after an update
def event(e = CalendarFixture.event)
  find(:xpath, "//a[contains(@class,'fc-day-grid-event')]"\
               "[contains(.,'#{event_title()}')]")
end

# Repeats result in multiple hits
def events(e = CalendarFixture.event)
  all(:xpath, "//a[contains(@class,'fc-day-grid-event')]"\
               "[contains(.,'#{event_title()}')]")
end

def open_event(e = CalendarFixture.event, occurance: 0)
  find_event(e,  occurance: occurance).trigger('click')
end

def find_event(e = CalendarFixture.event, occurance: 0)
  occurance.zero? ? event(e) : events(e)[occurance]
end

def check_events(occurances, e = CalendarFixture.event)
  expect(events().count).to eq(occurances)
end

def event_title(e = CalendarFixture.event)
  "#{tz(e.start).strftime('%-k:%M').lstrip} - #{tz(e.end).strftime('%-k:%M')} #{e.title}".lstrip
end

def tz(time)
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
  start = tz(event.start).change(:sec => 0)
  expect(start).to eql(tz(Time.parse(find('#event_start_date', visible:all).value)).change(:sec => 0))
  expect(start).to eql(tz(Time.parse(find('#event_start_time', visible:all).value)).change(:sec => 0))

  finish = tz(event.end).change(:sec => 0)
  expect(finish).to eql(tz(Time.parse(find('#event_end_date', visible:all).value)).change(:sec => 0))
  expect(finish).to eql(tz(Time.parse(find('#event_end_time', visible:all).value)).change(:sec => 0))
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
