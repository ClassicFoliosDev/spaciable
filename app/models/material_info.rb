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

  belongs_to :infoable, polymorphic: true
  has_many :heating_fuels_material_info, dependent: :destroy
  has_many :heating_fuels, through: :heating_fuels_material_info
  has_many :heating_sources_material_info, dependent: :destroy
  has_many :heating_sources, through: :heating_sources_material_info
  has_many :heating_outputs_material_info, dependent: :destroy
  has_many :heating_outputs, through: :heating_outputs_material_info

  amoeba do
    enable
    include_association :heating_fuels_material_info
    include_association :heating_sources_material_info
    include_association :heating_outputs_material_info
  end

  #Development update plot proliferation option
  PROLIFERATE = 1
end
