# frozen_string_literal: true

module Abilities
  module SiteAbilities
    def site_abilities(development_id, division_id, developer_id)
      crud_users(role: :site_admin, id: development_id, model: "Development")
      crud_residents(development_id)
      site_developments(development_id, division_id, developer_id)
      site_notifications(development_id, division_id, developer_id)
      site_faqs(development_id, division_id, developer_id)
      site_contacts(development_id, division_id, developer_id)
      site_documents(development_id, division_id, developer_id)
      custom_tiles(development_id)
    end

    private

    def site_developments(development_id, division_id, developer_id)
      can :read, Developer, id: developer_id
      can :read, Division, id: division_id
      can :read, Development, id: development_id
      can :read, Phase, development_id: development_id
      can :read, Room, development_id: development_id
      can :read, Plot, development_id: development_id

      can :read, UnitType, development_id: development_id

      unit_type_ids = UnitType.where(development: development_id).lazy.pluck(:id)
      can :read, Finish, rooms: { unit_type_id: unit_type_ids }
      can :read, Finish, rooms: { plot: { development_id: development_id } }
      can :read, Appliance, rooms: { unit_type_id: unit_type_ids }
      can :read, Appliance, rooms: { plot: { development_id: development_id } }
    end

    def site_notifications(development_id, division_id, developer_id)
      polymorphic_abilities Notification, :send_to do
        actions :read do
          type "Development", id: development_id
          type "Division", id: division_id if division_id
          type "Developer", id: developer_id
        end
      end

      cannot :send_to_all, Notification
      cannot :manage, Notification, send_to_all: true
    end

    def site_faqs(development, division, developer)
      polymorphic_abilities Faq, :faqable do
        type "Development", id: development, actions: :read
        type "Division", id: division, actions: :read if division
        type "Developer", id: developer, actions: :read
      end
    end

    def site_contacts(development, division, developer)
      polymorphic_abilities Contact, :contactable do
        type "Development", id: development, actions: :read
        type "Division", id: division, actions: :read if division
        type "Developer", id: developer, actions: :read
      end

      can :read, Contact, contactable_type: "Phase",
                          contactable_id: Phase.where(development_id: development).lazy.pluck(:id)
    end

    def site_documents(development, division, developer)
      polymorphic_abilities Document, :documentable do
        type "Division", id: division, actions: :read if division

        actions :read do
          type "Developer", id: developer
          type "Development", id: development
          type "UnitType", id: UnitType.where(development_id: development).lazy.pluck(:id)
          type "Phase", id: Phase.where(development_id: development).lazy.pluck(:id)
          type "Plot", id: Plot.where(development_id: development).lazy.pluck(:id)
        end
      end
    end

    def custom_tiles(development)
      can :read, CustomTile, development_id: development
    end
  end
end
