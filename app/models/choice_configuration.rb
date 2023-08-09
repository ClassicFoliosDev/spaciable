# frozen_string_literal: true

class ChoiceConfiguration < ApplicationRecord
  attr_accessor :unit_type

  belongs_to :development, optional: false
  has_many :room_configurations, dependent: :destroy
  has_many :plots, autosave: true, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :development_id }
  validates_with ParameterizableValidator

  delegate :to_s, to: :name
  delegate :division, to: :development
  delegate :developer, to: :development

  # create an (non database) accessor for each phase to bind to the form
  after_initialize do
    if development&.phases.present?
      development.phases.each do |phase|
        self.class.send(:attr_accessor, "phase_#{phase.id}_ids")
      end
    end
  end

  # Add the selected plots, then save.  As plots are 'autosaved' they
  # will be commited to the database at the same time and in the same transaction
  # as the ChoiceConfiguration
  # rubocop:disable Style/RedundantBegin, Style/RescueStandardError
  def persist(name, plotids, unit_type)
    # wrap in a transaction in case one of the updates fails.  This is only
    # necessary because we have to call save twice in this case
    success = true

    ChoiceConfiguration.transaction do
      begin
        self.name = name
        save
        associate_plots(plotids, id) # update the plots
        build_room_configurations(unit_type) # build rooms configs
        save # save choice_configuration and plot updates in one transaction
      rescue
        success = false
      end
    end
    success
  end
  # rubocop:enable Style/RedundantBegin, Style/RescueStandardError

  # Update the selected plots, then save.  As plots are 'autosaved' they
  # will be commited to the database at the same time and in the same transaction
  # as the ChoiceConfiguration
  def update_config(name, plotids)
    self.name = name
    update_plots(plotids)
    save # save the choice_configuration and plot updates in one transaction
  end

  # Update the plots by checking new against old
  def update_plots(updatedplots)
    oldplots = plots.present? ? plots.to_a.map(&:id).sort : nil
    # sort new plots
    newplots = updatedplots.nil? ? nil : updatedplots.sort

    # update
    if oldplots.present? && newplots.present?
      associate_plots(oldplots - newplots, nil)
      associate_plots(newplots - oldplots, id)
    elsif oldplots.present?
      associate_plots(oldplots, nil) # remove old
    elsif newplots.present?
      associate_plots(newplots, id) # add new
    end
  end

  # create associated room_configurations if necessary
  def build_room_configurations(unit_type)
    return true if unit_type.blank?

    UnitType.find(unit_type.to_i)&.rooms&.each do |room|
      room_configurations << RoomConfiguration.new(choice_configuration_id: id,
                                                   name: room.name,
                                                   icon_name: room.icon_name)
    end
  end

  private

  # Associate the id/nil with the supplied plots
  def associate_plots(plotids, cc_id)
    return true if plotids.blank?

    Plot.where(id: plotids).map { |p| p.update(choice_configuration_id: cc_id) }
  end
end
