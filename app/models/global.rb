# frozen_string_literal: true

# Timeline Task actions.
class Global < ApplicationRecord
  GLOBAL = "CFAdmin"
  has_many :timelines, as: :timelineable

  # Get the global parent record
  def self.root
    Global.find_by(name: GLOBAL)
  end

  # Get all the timelines
  def self.timelines
    root.timelines
  end
end
