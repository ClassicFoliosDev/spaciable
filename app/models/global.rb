# frozen_string_literal: true

# Timeline Task actions.
class Global < ApplicationRecord
  GLOBAL = "CFAdmin"
  has_many :timelines, as: :timelineable
  has_one :build_sequence, as: :build_sequenceable
  alias sequence_in_use build_sequence

  # Get the global parent record
  def self.root
    Global.find_by(name: GLOBAL)
  end

  # Get all the timelines
  def self.timelines
    root.timelines
  end

  # get the default build sequence
  def self.build_sequence
    root.build_sequence
  end

  # rubocop:disable SkipsModelValidations
  def update_build_steps(old_ids, new_id)
    @updated ||= []
    targets = Plot.where.not(id: @updated)
                  .where(build_step_id: old_ids)
    @updated += targets.pluck(:id)
    targets.update_all(build_step_id: new_id)
  end
  # rubocop:enable SkipsModelValidations

  def identity
    "Global"
  end
end
