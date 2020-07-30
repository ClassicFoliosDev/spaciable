# frozen_string_literal: true

module SearchConcern
  extend ActiveSupport::Concern

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

  # Full search of finish name/type/manufacturer
  # rubocop:disable Metrics/MethodLength
  def finish_full_search(search_term)
    search_tokens = search_term.split(" ")
    finishes = []

    search_tokens.each do |token|
      finishes << Finish.where("LOWER(finishes.name) LIKE LOWER(?)",
                               "%#{token}%").accessible_by(current_ability, :read)

      manufacturers = FinishManufacturer.where("LOWER(name) LIKE LOWER(?)", "%#{token}%")
      finishes << Finish.includes(:finish_manufacturer)
                  .where(finish_manufacturer_id: manufacturers)
                        .accessible_by(current_ability, :read)
      types = FinishType.where("LOWER(name) LIKE LOWER(?)", "%#{token}%")
      finishes << Finish.includes(:finish_type)
                  .where(finish_type_id: types)
                        .accessible_by(current_ability, :read)
    end

    finishes.flatten.to_set.flatten
  end
  # rubocop:enable Metrics/MethodLength

  # Full search of resident name/email
  def resident_search(term)
    Resident.where("CONCAT_WS(' ', LOWER(first_name), LOWER(last_name)) LIKE ?",
                   "%#{term}%")
            .or(Resident.where("LOWER(email) LIKE LOWER(?)", "%#{term}%"))
  end

  # Full search of admins name/email
  def admin_search(term)
    User.where("CONCAT_WS(' ', LOWER(first_name), LOWER(last_name)) LIKE ?",
               "%#{term}%")
        .or(User.where("LOWER(email) LIKE LOWER(?)", "%#{term}%"))
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
    Faq.where("LOWER(question) LIKE LOWER(?)",
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
