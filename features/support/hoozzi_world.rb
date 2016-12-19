# frozen_string_literal: true
module HoozziWorld
  def t(*args)
    I18n.t(*args)
  end

  def delete_and_confirm!
    # Launches the confirmation dialog
    btn = find(".archive-btn")
    # HACK! Can't get around needing this sleep :(
    sleep 0.5
    btn.click

    # Click the "real" delete in the confirmation dialog
    find(".btn-delete").trigger("click")
  end
end
