# frozen_string_literal: true

class BuildSequence < ApplicationRecord
  belongs_to :build_sequenceable, polymorphic: true
  alias parent build_sequenceable

  has_many :developers
  has_many :divisions
  has_many :build_steps, -> { order(:order) }, dependent: :destroy
  accepts_nested_attributes_for :build_steps, allow_destroy: true

  # Update all the plots using this build sequence
  def update_build_steps(old_ids, new_id)
    # update is specialised by the parent
    parent.update_plots(old_ids, new_id)
  end
end
