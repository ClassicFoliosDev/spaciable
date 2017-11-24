Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 1
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

Delayed::Worker.queue_attributes = {
  inbound_message: { priority: -10 },
  outbound_message: { priority: -10 },
  escalation: { priority: -10 },
  device_reg: { priority: -9 },
  translation: { priority: -8 },
  broadcast: { priority: -7 },
  delivery_webhook: { priority: -7 },
  referral_webhook: { priority: -6 },
  account_webhook: { priority: -6 },
  default: { priority: 0 }
}
