module Sleeps
  def wait_for_branding_to_reload
    sleep 2
  end

  # wait until the last updated time on table is after the 'after' value
  def wait_for_update_to_complete(before, table)
    (0..5).each do |_|
      break unless table.order(:updated_at).last.updated_at > before
      sleep 1
    end
  end
end
