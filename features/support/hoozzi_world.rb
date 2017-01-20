# frozen_string_literal: true
module HoozziWorld
  def t(*args)
    I18n.t(*args)
  end

  def select_from_selectmenu(field, with:, debug: false)
    stdout "Select from: #{field} with: #{with}", show: debug

    expand_selectmenu(field)

    list, list_text = selectmenu_list_items
    stdout "Options: #{list_text}", show: debug

    item = click_on_item_from_list(list, text: with)
    stdout "Item selected: #{item&.text}", show: debug

    sleep 0.3
  rescue => e
    screenshot if debug
    raise e
  end

  def expand_selectmenu(field)
    within ".#{field}" do
      arrow = page.find ".ui-icon"
      arrow.click
    end
  end

  def selectmenu_list_items
    ul = page.find ".ui-menu"
    list = ul.all("li")

    [list, list.map(&:text).join(", ")]
  end

  def click_on_item_from_list(list, text:)
    item = list.find { |node| node.text.strip == text.to_s.strip }
    item.click
    item
  end

  def stdout(text, show: true)
    STDOUT.puts "DEBUG:   #{text}" if show
  end

  def delete_and_confirm!(scope: "", finder_options: {})
    # Launches the confirmation dialog
    if scope.blank?
      click_archive_btn(finder_options)
    else
      within scope do
        click_archive_btn(finder_options)
      end
    end

    sleep 0.3
    # Click the "real" delete in the confirmation dialog
    within ".ui-dialog" do
      find(".btn-delete").trigger("click")
    end
  end

  private

  def click_archive_btn(finder_options)
    btn = find(".archive-btn", finder_options)

    # HACK! Can't get around needing this sleep :(
    sleep 0.3
    btn.click
  end
end
