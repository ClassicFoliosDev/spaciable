# frozen_string_literal: true

class Letting < ApplicationRecord
  belongs_to :plot, optional: false
  belongs_to :lettings_account, optional: false

  has_one :phase, through: :plot

  delegate :management, to: :lettings_account

  delegate :letter, to: :lettings_account
  delegate :letter_type, to: :lettings_account
  delegate :letter_id, to: :lettings_account

  def self.current_resident_letting(resident, plot)
    letting = Letting.find_by(plot_id: plot.id)
    return unless letting
    letting.letter == resident
  end

  def self.resident_letter(plot)
    letting = Letting.find_by(plot_id: plot.id)
    return unless letting
    Resident.find_by(id: letting.letter_id)
  end

  def self.other_resident_lettings(plots)
    other_letting = false
    plots.each do |plot|
      letting = Letting.find_by(plot_id: plot.id)
      return other_letting = true if letting
    end
    other_letting
  end
end
