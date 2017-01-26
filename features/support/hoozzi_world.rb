# frozen_string_literal: true
module HoozziWorld
  def t(*args)
    I18n.t(*args)
  end

  def select_from_selectmenu(field, with:)
    stdout "Select from: #{field} with: #{with}"

    expand_selectmenu(field)
    sleep 0.3

    list, list_text = selectmenu_list_items
    stdout "Options: #{list_text}"

    item = click_on_item_from_list(list, text: with.to_s)
    stdout "Item selected: #{item&.text}"

    sleep 0.3
  rescue => e
    screenshot if ENV.fetch("DEBUG", false)
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

  def stdout(text, show: ENV.fetch("DEBUG", false))
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
