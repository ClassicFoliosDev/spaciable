# frozen_string_literal: true

require "capybara/poltergeist"

Capybara.default_max_wait_time = 10
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, window_size: [1600, 1200], url_whitelist: ["http://127.0.0.1"])
end

if ENV["DEBUG"] == "true"
  Capybara.register_driver :debug do |app|
    Capybara::Poltergeist::Driver.new(app, js_errors: false,inspector: true, window_size: [1600, 1200], url_whitelist: ["http://127.0.0.1"])
  end
  Capybara.javascript_driver = :debug
end

Capybara.register_driver :android_mobile do |app|
  android = Capybara::Poltergeist::Driver.new(app, js_errors: false, inspector: true)
  android.headers = { 'User-Agent' => 'Mozilla/5.0 (Linux; U; Android 4.4.2; en-us; SCH-I535 Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30' }
  android
end

Capybara.register_driver :apple_mobile do |app|
  apple = Capybara::Poltergeist::Driver.new(app, js_errors: false, inspector: true)
  apple.headers = { 'User-Agent' => 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1' }
  apple
end
