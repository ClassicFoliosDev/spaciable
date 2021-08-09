# frozen_string_literal: true

module SpecUtilities
  def t(*args)
    I18n.t(*args)
  end

  def fill_in_ckeditor(locator, opts)
    content = opts.fetch(:with).to_json # convert to a safe javascript string
    tries = 0

    begin
      tries += 1
      sleep 0.3
      set_ckeditor_content(locator, content)

      raise "didn't work" if find("##{locator}", visible: false).value != opts[:with]
    rescue
      retry if tries < 3
      raise "Could not set CKEDITOR content for #{locator}"
    end
  end

  def set_ckeditor_content(locator, content)
    page.execute_script <<-SCRIPT
      CKEDITOR.instances['#{locator}'].setData(#{content});
      $('textarea##{locator}').text(#{content});
    SCRIPT
  end

  def select_from_selectmenu(field, with:, skip_if: :already_selected)
    stdout "Select from: #{field} with: #{with}"
    return (stdout "Skipping: #{skip_if}") if really_skip_select?(skip_if, with, field)

    expand_selectmenu(field)
    sleep 1

    list, list_text = selectmenu_list_items(field)
    stdout "Options: #{list_text}"

    click_on_item_from_list(list, field, text: with.to_s)

    sleep 0.5
  rescue => e
    screenshot if ENV.fetch("DEBUG", false)
    raise e
  end

  def really_skip_select?(check, value, field)
    skip = false

    if check == :already_selected
      begin
        within(".#{field} .ui-selectmenu-text") do
          skip = text == value
        end
        rescue
          within(".#{field}") do
            skip = text.include?(value)
        end
      end
    end

    skip
  end

  def expand_selectmenu(field)
    within ".#{field}" do
      begin
        arrow = page.find ".ui-icon"
      rescue Capybara::ElementNotFound
        screenshot if debug_mode?
        raise Capybara::ElementNotFound, "Selectmenu is missing for #{field}"
      end
      sleep 0.2
      arrow.trigger('click')
    end
  end

  def selectmenu_list_items(field)
    # Find the parent span for the ui-selectmenu-text beneth the 'field'
    span = find(:xpath, "//div[contains(concat(' ', @class, ' '), ' #{field} ')]//span[contains(@class, 'ui-selectmenu-text')]/parent::span")
    # The span and the menu are associated through their names
    ul = find("##{span[:id].gsub('button', 'menu')}", wait: 5)
    list = ul.all("li")
    [list, list.map(&:text).join(", ")]
  end

  def click_on_item_from_list(list, field, text:)
    item = list.detect(-> { :not_found }) { |node| node.text.strip == text.to_s.strip }

    item = try_clicking_on_selectmenu_item_again(field, text) if item == :not_found

    item.click
  end

  def try_clicking_on_selectmenu_item_again(field, text)
    stdout "Couldn't find item #{text}, trying again..."
    sleep 0.3

    retry_list, list_text = selectmenu_list_items(field)
    stdout "Retried list options: #{list_text}"

    item = retry_list.find(-> { :not_found }) { |node| node.text.strip == text.to_s.strip }
    raise "Cannot find item '#{text}' in options: #{list_text}" if item == :not_found

    item
  end

  def stdout(text, show: debug_mode?)
    STDOUT.puts "DEBUG:   #{text}" if show
  end

  def delete_and_confirm_lnk!(scope: "")
    delete_and_confirm!(scope: scope, is_link: true)
  end

  def delete_and_confirm!(scope: "", finder_options: { wait: 0.4, visible: true }, is_link: false)
    target = ".archive-#{is_link ? 'lnk' : 'btn'}"

    # Launches the confirmation dialog
    if scope.blank?
      within ".record-list" do
        click_archive(target, finder_options)
      end
    else
      within scope do
        click_archive(target, finder_options)
      end
    end

    # Click the "real" delete in the confirmation dialog
    within find(:xpath, "//div[contains(@class, 'archive-dialog')]") do
      find(".btn-delete").trigger(:click)
    end
  end

  def debug_mode?
    ENV.fetch("DEBUG", false)
  end

  private

  def click_archive(target, finder_options)
    btn = find(target, finder_options)
    sleep 0.1
    btn.trigger(:click)
  end
end
