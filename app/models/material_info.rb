# frozen_string_literal: true

class MaterialInfo < ApplicationRecord
  include TenureEnum
  include CouncilTaxBandEnum
  include PropertyTypeEnum
  include FloorEnum
  include EpcRatingEnum
  include PropertyConstructionEnum
  include ElectricitySupplyEnum
  include WaterSupplyEnum
  include SewerageEnum
  include BroadbandEnum
  include MobileSignalEnum
  include ParkingEnum

  after_save :update_dependents

  belongs_to :infoable, polymorphic: true
  has_many :heating_fuels_material_info, dependent: :destroy
  has_many :heating_fuels, through: :heating_fuels_material_info
  has_many :heating_sources_material_info, dependent: :destroy
  has_many :heating_sources, through: :heating_sources_material_info
  has_many :heating_outputs_material_info, dependent: :destroy
  has_many :heating_outputs, through: :heating_outputs_material_info

  attr_accessor :proliferate
  attr_accessor :heating_fuels_updated
  attr_accessor :heating_sources_updated
  attr_accessor :heating_outputs_updated

  amoeba do
    enable
    include_association :heating_fuels_material_info
    include_association :heating_sources_material_info
    include_association :heating_outputs_material_info
  end

  # Development update plot proliferation option
  PROLIFERATE = 1

  # rubocop:disable SkipsModelValidations, Metrics/MethodLength, Metrics/AbcSize
  def update_dependents
    return unless infoable.is_a?(Development)

    return if proliferate.blank?

    updates = {}
    %w[tenure
       service_charges
       council_tax_band
       property_type
       property_construction
       property_construction_other
       council_tax_band
       parking
       epc_rating
       electricity_supply
       electricity_supply_other
       water_supply
       sewerage
       sewerage_other
       broadband
       mobile_signal
       mobile_signal_restrictions
       building_safety
       restrictions
       rights_and_easements
       flood_risk
       planning_permission_or_proposals
       accessibility
       coalfield_or_mining_areas
       other_considerations].each do |field|
      updates[field.to_sym] = send(field) if send("saved_change_to_" + field + "?")
    end

    MaterialInfo.where(infoable: infoable.plots).update_all(updates) unless updates.empty?

    %w[heating_fuel heating_source heating_output].each do |heat|
      next unless send("#{heat}s_updated") == "true"

      MaterialInfo.where(infoable: infoable.plots).find_each do |plot|
        plot.send("#{heat}s").destroy_all
        send("#{heat}s").each do |h|
          plot.send("#{heat}s_material_info").create(heat.to_sym => h)
        end
        plot.save
      end
    end
  end
  # rubocop:enable SkipsModelValidations, Metrics/MethodLength, Metrics/AbcSize
end
