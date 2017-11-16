# frozen_string_literal: true

module SearchConcern
  extend ActiveSupport::Concern

  def ilike_search(resources, search_term)
    resources.where("LOWER(name) LIKE LOWER(?)", "%#{search_term}%")
  end

  def appliance_search(search_term)
    search_tokens = search_term.split(" ")
    appliances = []

    search_tokens.each do |token|
      appliances << Appliance.where("LOWER(model_num) LIKE LOWER(?)",
                                    "%#{token}%").accessible_by(current_ability, :read)

      manufacturers = ApplianceManufacturer.where("LOWER(name) LIKE LOWER(?)", "%#{token}%")
      appliances << Appliance.includes(:appliance_manufacturer)
                    .where(appliance_manufacturer_id: manufacturers)
                             .accessible_by(current_ability, :read)
    end

    appliances.flatten.to_set.flatten
  end

  def room_search(search_term)
    Room.where("LOWER(name) LIKE LOWER(?)",
               "%#{search_term}%").accessible_by(current_ability, :read)
  end

  def document_search(search_term)
    Document.where("LOWER(title) LIKE LOWER(?)",
                   "%#{search_term}%").accessible_by(current_ability, :read)
  end

  def contact_search(search_term)
    Contact.where("LOWER(concat_ws(' ', first_name, last_name, position))
                  LIKE LOWER(?)", "%#{search_term}%").accessible_by(current_ability, :read)
  end

  def faq_search(search_term)
    Faq.where("LOWER(question || answer) LIKE LOWER(?)",
              "%#{search_term}%").accessible_by(current_ability, :read)
  end

  def finish_search(search_term)
    Finish.where("LOWER(finishes.name) LIKE LOWER(?)",
                 "%#{search_term}%").accessible_by(current_ability, :read)
  end

  def notification_search(search_term)
    current_resident.notifications.where("LOWER(subject || message) LIKE LOWER(?)",
                                         "%#{search_term}%")
  end

  def how_to_search(search_term)
    HowTo.where("LOWER(title || summary || description) LIKE LOWER(?)",
                "%#{search_term}%").accessible_by(current_ability, :read)
  end
end
