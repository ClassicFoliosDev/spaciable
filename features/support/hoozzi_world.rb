# frozen_string_literal: true
module HoozziWorld
  def t(*args)
    I18n.t(*args)
  end

  def delete_and_confirm!(finder_options: {})
    # Find the first delete button
    within ".record-list" do
      btn = find(".archive-btn", finder_options).click
      # Launch the confirmation dialog
      btn.trigger("click")
    end

    sleep 0.5
    # Click the "real" delete in the confirmation dialog
    within ".ui-dialog" do
      find(".btn-delete").trigger("click")
    end
  end
end
