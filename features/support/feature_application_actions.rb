# frozen_string_literal: true

module FeatureApplicationActions
  def refresh_to_ensure_persistence
    visit(current_path)
  end
end
