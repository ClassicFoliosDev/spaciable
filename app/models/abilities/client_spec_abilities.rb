# frozen_string_literal: true

module Abilities
  module ClientSpecAbilities
    def client_spec_abilities(developer, development_ids, user)
      return if developer.blank?
      # developer and user have to have CAS
      return unless Developer.find(developer).cas && user.cas

      crud_finishes(developer)
      crud_appliances(developer)
      cas_development_abilities(development_ids, user)
      true
    end

    private

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def cas_development_abilities(development_ids, user)
      Development.where(id: development_ids).find_each do |development|
        next unless development.cas
        can :crud, UnitType, development_id: development.id
        can %i[crud remove_finish remove_appliance], Room, development_id: development.id
        can :create, FinishRoom,
            added_by: user.display_name,
            room: { development_id: development.id }
        can :destroy, FinishRoom, room: { development_id: development.id }
        can :create, ApplianceRoom,
            added_by: user.display_name,
            room: { development_id: development.id }
        can :destroy, ApplianceRoom, room: { development_id: development.id }
        can :create, FinishRoom, room: { development_id: development.id }
        can :create, ApplianceRoom, room: { development_id: development.id }
        can %i[cas_update update], Plot, development_id: development.id
        can %i[bulk_edit cas_update], Phase, development_id: development.id
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def crud_finishes(developer_id)
      crud_finclass(Finish, developer_id)
      crud_finclass(FinishType, developer_id)
      crud_finclass(FinishCategory, developer_id)
      crud_finclass(FinishManufacturer, developer_id)
    end

    # Generic ability for any class with a developer_id attribute that
    # needs to be distinct from Admin objects
    def crud_finclass(klass, developer_id)
      # Can read records developer_id is that of the developer trying to read
      can :read,
          klass,
          ["#{klass.table_name}.developer_id = ?", developer_id] \
           do |instance|
        instance.developer_id == developer_id
      end

      duc_class(klass, developer_id)
    end

    def crud_appliances(developer_id)
      crud_appclass(Appliance, developer_id, "model_num")
      crud_appclass(ApplianceCategory, developer_id)
      crud_appclass(ApplianceManufacturer, developer_id)
    end

    # Generic ability for any class with a developer_id attribute that
    # needs to share with Admin objects
    def crud_appclass(klass, developer_id, key = "name")
      # Can read records providing the ('key' is unique and develper_id is null (ie CF records))
      # or the developer_id is that of the developer trying to read
      can :read,
          klass,
          ["#{klass.table_name}.id IN (select id from #{klass.table_name} k " \
           "where ((k.developer_id IS NULL AND (select count(*) " \
           "from #{klass.table_name} k2 where k2.#{key} = #{klass.table_name}.#{key} " \
           "AND  k2.developer_id = #{developer_id}) = 0) or k.developer_id = #{developer_id}))"] \
           do |instance|
        instance.developer_id == developer_id || instance.developer_id.nil?
      end

      duc_class(klass, developer_id)
    end

    # restrict destroy, update and create
    def duc_class(klass, developer_id)
      # Can only destroy or update an instance if the developer_id matches
      # the developer trying to delete
      can %i[destroy update], klass do |instance|
        instance.developer_id == developer_id
      end

      # Creates klass objects initialised with developer_id of the
      # logged in developer
      can :create, klass, developer_id: developer_id
    end
  end
end
