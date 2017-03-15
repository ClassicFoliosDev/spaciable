# frozen_string_literal: true
module Abilities
  module DeveloperAbilities
    include PolymorphicAssociationAbilities

    def developer_abilities(developer)
      crud_users(role: :developer_admin, id: developer, model: "Developer")

      developer_notifications(developer)
      developer_faqs(developer)
      developer_contacts(developer)
      developer_documents(developer)
      crud_developers(developer)
      read_developers(developer)
    end

    private

    def developer_faqs(developer_id)
      polymorphic_abilities Faq, :faqable do
        type "Developer", id: developer_id, actions: :manage
      end
    end

    def developer_notifications(developer_id)
      polymorphic_abilities Notification, :send_to do
        type "Developer", id: developer_id, actions: :manage
      end

      cannot :manage, Notification, send_to_all: true
    end

    def developer_contacts(developer_id)
      polymorphic_abilities Contact, :contactable do
        type "Developer", id: developer_id, actions: :manage
      end
    end

    def developer_documents(developer_id)
      polymorphic_abilities Document, :documentable do
        actions :manage do
          type "Developer", id: developer_id
          type "UnitType", id: UnitType.where(developer_id: developer_id).pluck(:id)
          type "Phase", id: Phase.where(developer_id: developer_id).pluck(:id)
          type "Plot", id: Plot.where(developer_id: developer_id).pluck(:id)
        end
      end
    end

    def crud_developers(developer_id)
      can :crud, Finish, developer_id: developer_id
      can :crud, Plot, developer_id: developer_id
    end

    def read_developers(developer_id)
      can :read, Developer, id: developer_id
      can :read, Development, developer_id: developer_id
      can :read, Development, developer_id: developer_id
      can :read, Division, developer_id: developer_id
      can :read, Phase, developer_id: developer_id
      can :read, Room, developer_id: developer_id
      can :read, UnitType, developer_id: developer_id
    end
  end
end
