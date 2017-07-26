# frozen_string_literal: true
module Abilities
  module ResidentAbilities
    def resident_abilities(resident)
      plot = resident.plot
      return unless plot

      can :manage, Resident, id: resident.id
      can :read, HowTo

      resident_abilities_for_plot(plot.id)
      resident_abilities_via_development(plot.development_id)
      resident_abilities_via_unit_type(plot.unit_type_id, plot.rooms.pluck(:id))
      resident_abilities_for_documents(plot)
      resident_abilities_for_contacts(plot)
      resident_abilities_for_faqs(plot)
      resident_abilities_for_notifications(plot)
      resident_abilities_for_private_documents(resident.id)
      resident_brand_abilities(plot)
    end

    def resident_abilities_for_plot(plot_id)
      can :read, Plot, id: plot_id
    end

    def resident_abilities_via_development(development_id)
      can :read, Developer, developments: { id: development_id }
      can :read, Division, developments: { id: development_id }
      can :read, Development, id: development_id
      can :read, Phase, development_id: development_id
    end

    def resident_abilities_via_unit_type(unit_type_id, room_ids)
      can :read, UnitType, id: unit_type_id
      can :read, Room, id: room_ids
      can :read, Finish, rooms: { id: room_ids }
      can :read, Appliance, rooms: { id: room_ids }
    end

    def resident_abilities_for_documents(plot)
      can :read, Document, documentable_type: "UnitType", documentable_id: plot.unit_type_id
      can :read, Document, documentable_type: "Plot", documentable_id: plot.id
      can :read, Document, documentable_type: "Phase", documentable_id: plot.phase_id
      can :read, Document, documentable_type: "Development", documentable_id: plot.development_id
      can :read, Document, documentable_type: "Developer",
                           documentable_id: plot.developer_id, division_id: nil
      can :read, Document, documentable_type: "Division", documentable_id: plot.division_id
    end

    def resident_abilities_for_contacts(plot)
      can :read, Contact, development_id: plot.development_id, contactable_type: "Development"
      can :read, Contact, developer_id: plot.developer_id, contactable_type: "Developer"
      can :read, Contact, division_id: plot.division_id, contactable_type: "Division"
    end

    def resident_abilities_for_faqs(plot)
      can :read, Faq, development_id: plot.development_id, faqable_type: "Development"
      can :read, Faq, developer_id: plot.developer_id, faqable_type: "Developer"
      can :read, Faq, division_id: plot.division_id, faqable_type: "Division"
    end

    def resident_abilities_for_notifications(plot)
      can :read, Notification, development_id: plot.development_id
      can :read, Notification, developer_id: plot.developer_id, division_id: nil
      can :read, Notification, division_id: plot.division_id if plot.division_id?

      resident_plot_number_notifications(plot)
    end

    private

    def resident_plot_number_notifications(plot)
      cannot :read, Notification do |notification|
        # If a plot range has been defined for the notification:
        #   Resident cannot read a notification that does not include their plot number
        notification.plot_numbers.exclude?(plot.number.to_s) if notification.plot_numbers.any?
      end
    end

    def resident_brand_abilities(plot)
      polymorphic_abilities Brand, :brandable do
        type "Developer", id: plot.developer_id, actions: :read
        type "Division", id: plot.division_id, actions: :read
        type "Development", id: plot.development_id, actions: :read
        type "Phase", id: plot.phase_id, actions: :read
      end
    end

    def resident_abilities_for_private_documents(current_resident_id)
      can :manage, PrivateDocument, resident_id: current_resident_id
    end
  end
end
