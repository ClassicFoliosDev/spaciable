# frozen_string_literal: true

module Abilities
  module ResidentAbilities
    def resident_abilities(resident, plot)
      return unless plot

      can :manage, Resident, id: resident.id
      can :read, HowTo

      resident_abilities_for_plot(plot.id)
      resident_abilities_via_development(plot.development_id)
      resident_abilities_via_unit_type(plot.unit_type_id, plot.rooms.pluck(:id))
      resident_abilities_for_documents(plot, resident)
      resident_abilities_for_contacts(plot)
      resident_abilities_for_faqs(plot)
      resident_abilities_for_notifications(plot)
      resident_abilities_for_private_documents(resident, plot)
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

    def resident_abilities_for_documents(plot, resident)
      if resident.plot_residency_homeowner?(plot) || resident.admin_preview
        homeowner_read(plot)
      else
        tenant_read(plot)
      end
    end

    def homeowner_read(plot)
      can :read, Document, documentable_type: "UnitType", documentable_id: plot.unit_type_id
      can :read, Document, documentable_type: "Plot", documentable_id: plot.id
      can :read, Document, documentable_type: "Phase", documentable_id: plot.phase_id
      can :read, Document, documentable_type: "Development", documentable_id: plot.development_id
      can :read, Document, documentable_type: "Developer", documentable_id: plot.developer_id
      can :read, Document, documentable_type: "Division", documentable_id: plot.division_id
    end

    def tenant_read(plot)
      # If the document has been shared for this plot, all residents can read it including tenants
      ids = plot.plot_documents.where(enable_tenant_read: true).pluck(:document_id)
      can :read, Document, id: ids
    end

    def resident_abilities_for_contacts(plot)
      can :read, Contact, contactable_id: plot.development_id, contactable_type: "Development"
      can :read, Contact, contactable_id: plot.developer_id, contactable_type: "Developer"
      can :read, Contact, contactable_id: plot.division_id, contactable_type: "Division"
      can :read, Contact, contactable_id: plot.phase_id, contactable_type: "Phase"
    end

    def resident_abilities_for_faqs(plot)
      can :read, Faq, faqable_id: plot.development_id, faqable_type: "Development",
                      faq_type: { construction_type:
                                  { construction: Development.constructions[plot.construction] } }
      can :read, Faq, faqable_id: plot.developer_id, faqable_type: "Developer",
                      faq_type: { construction_type:
                                  { construction: Development.constructions[plot.construction] } }
      can :read, Faq, faqable_id: plot.division_id, faqable_type: "Division",
                      faq_type: { construction_type:
                                  { construction: Development.constructions[plot.construction] } }
      can :read, FaqType
      can :read, FaqCategory
    end

    def resident_abilities_for_notifications(plot)
      can :read, Notification, send_to_id: plot.development_id, send_to_type: "Development"
      can :read, Notification, send_to_id: plot.developer_id, send_to_type: "Developer"
      if plot.division_id?
        can :read, Notification, send_to_id: plot.division_id,
                                 send_to_type: "Division"
      end
      can :read, Notification, send_to_id: plot.id, send_to_type: "Plot"

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

    def resident_abilities_for_private_documents(current_resident, plot)
      # Legacy documents may have no plot id, if so, allow resident to manage them all
      can :manage, PrivateDocument, resident_id: current_resident.id, plot_id: nil

      # New documents should have a plot id
      can :manage, PrivateDocument, resident_id: current_resident.id, plot_id: plot.id

      # If the document has been shared for this plot, all residents can read it including tenants
      ids = plot.plot_private_documents.where(enable_tenant_read: true).pluck(:private_document_id)
      can :read, PrivateDocument, id: ids
    end
  end
end
