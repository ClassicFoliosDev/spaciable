# frozen_string_literal: true
module HoozziWorld
  def t(*args)
    I18n.t(*args)
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
