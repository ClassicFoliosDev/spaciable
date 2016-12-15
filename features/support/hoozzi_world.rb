module HoozziWorld
  def t(*args)
    I18n.t(*args)
  end

  def screenshot
    sleep 0.5
    save_and_open_screenshot
  end

  def debug_html
    sleep 0.5
    save_and_open_page
  end

  def debug_dom
    if ENV["DEBUG"] == "true"
      page.driver.debug
    else
      puts <<~HINT
      #{'*' * 100}
      To use the `debug_dom` method, re-run the test but set the DEBUG environment variable:

      $ bundle exec cucumber DEBUG=true

      #{'*' * 100}
      HINT
    end
  end
end
