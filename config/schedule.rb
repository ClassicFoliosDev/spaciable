# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


# plot expiry mailers
every 1.day, at: '12:10 am' do
  runner "Plot.notify_expiry_plots"
end

# resident expiry mailers
every 1.day, at: '12:15 am' do
  runner "Resident.notify_expiry"
end

# destroy unconfirmed referrals after 28 days
every 1.day, at: '3:00 am' do
  runner "Referral.delete_28_days_old"
end

# downgrade expired premium users of Vaboo
every 1.day, at: '2:00 am' do
  runner "Vaboo.check_expired_premium"
end

# admin resident invitation email report
every :monday, at: '8:00am' do
  runner "Invitation.resident_invitation_summary"
end

every '0 0 1 * *' do
  runner "Package.invoice_developers"
end

every 1.day, at: '2:00 am' do
  runner "AutoComplete.now"
end
