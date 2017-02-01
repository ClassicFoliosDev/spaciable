# frozen_string_literal: true
module Abilities
  module DivisionAbilities
    def division_abilities(division, developer_id)
      crud_users(role: :division_admin, id: division, model: "Division")

      division_notifications(division, developer_id)
      division_faqs(division, developer_id)
      division_contacts(division, developer_id)
      crud_divisions(division)
      read_divisions(developer_id, division)
    end

    private

    def crud_divisions(division)
      can :crud, Document, division_id: division
      can :crud, Finish, division_id: division
      can :crud, Image, division_id: division
      can :crud, Plot, division_id: division
    end

    def read_divisions(developer_id, division)
      can :read, Developer, id: developer_id
      can :read, Development, division_id: division
      can :read, Division, id: division
      can :read, Phase, division_id: division
      can :read, Room, division_id: division
      can :read, UnitType, division_id: division
    end

    def division_notifications(division, developer)
      polymorphic_abilities Notification, :send_to do
        type "Division", id: division, actions: :manage
        type "Developer", id: developer, actions: :read
      end

      cannot :manage, Notification, send_to_all: true
    end

    def division_faqs(division, developer)
      polymorphic_abilities Faq, :faqable do
        type "Division", id: division, actions: :manage
        type "Developer", id: developer, actions: :read
      end
    end

    def division_contacts(division, developer)
      polymorphic_abilities Contact, :contactable do
        type "Division", id: division, actions: :manage
        type "Developer", id: developer, actions: :read
      end
    end
  end
end
