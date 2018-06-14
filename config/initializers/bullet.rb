if Rails.env.development?
  Bullet.enable = true
  # Turn off alerts temporarily, while we have prototype code that is not optimised
  # Bullet.alert = true
  Bullet.bullet_logger = true
  Bullet.console = true
  Bullet.rails_logger = true
  Bullet.add_footer = Features.bullet_footer?
  # Not using slack
  # Bullet.slack = { webhook_url: 'https://classic-folios.slack.com/', channel: '#client-isyt', username: 'bullet-notifier' }

  Bullet.add_whitelist(type: :unused_eager_loading, class_name: "Room", association: :finish_manufacturers)
  Bullet.add_whitelist(type: :unused_eager_loading, class_name: "Room", association: :appliance_manufacturers)
  Bullet.add_whitelist(type: :unused_eager_loading, class_name: "Room", association: :appliance_categories)
  Bullet.add_whitelist(type: :unused_eager_loading, class_name: "Plot", association: :division)
end
