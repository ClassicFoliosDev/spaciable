# frozen_string_literal: true
module SearchConcern
  extend ActiveSupport::Concern

  def ilike_search(resources, search_term)
    resources.where("LOWER(name) ILIKE LOWER(?)", "%#{search_term}%")
  end

  def appliance_search(search_term)
    models = Appliance.where("LOWER(model_num) ILIKE LOWER(?)", "%#{search_term}%")
    manufacturers = ApplianceManufacturer.where("LOWER(name) ILIKE LOWER(?)", "%#{search_term}%")
    appliances = Appliance.where(appliance_manufacturer_id: manufacturers)

    (models + appliances).uniq
  end
end
