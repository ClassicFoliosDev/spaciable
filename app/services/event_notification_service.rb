# frozen_string_literal: true

module EventNotificationService
  module_function

  # Clear any current reminder, then generate a new
  # one if necessary.  Return the id of the reminder job
  def remind(event)
    clear_reminder(event)
    reminder(event)&.provider_job_id
  end

  def clear_reminder(event)
    return unless event.reminder_id

    reminder = Delayed::Job.find_by(id: event.reminder_id)
    return unless reminder

    reminder.delete
  end

  def reminder(event)
    return nil if event.nix?

    EventReminderJob.set(wait_until: event.notify_at).perform_later(event)
  end

  def invite(event, resource_ids)
    EventInvitationJob.perform_now(event, resource_ids)
  end

  def update(event, resource_ids)
    EventUpdateJob.perform_now(event, resource_ids)
  end

  def cancel(event, resource_ids)
    EventCancellationJob.perform_now(event, resource_ids)
  end
end
