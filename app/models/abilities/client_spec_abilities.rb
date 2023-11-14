# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module Abilities
  module ClientSpecAbilities
    def client_spec_abilities(developer, development_ids, role)
      return if developer.blank?
      # developer and role have to have CAS
      return unless Developer.find(developer).cas && role.cas

      crud_finishes(developer)
      crud_appliances(developer)
      cas_development_abilities(development_ids)
      true
    end

    private

    def cas_development_abilities(development_ids)
      Development.where(id: development_ids).find_each do |development|
        next unless development.cas

        development.phases.each do |phase|
          next if phase.free?

          crud_plot_rooms(development, phase)
          crud_finish_rooms(development, phase)
          crud_appliance_rooms(development, phase)
        end
        crud_rooms(development)
        crud_unit_types(development)
        crud_plots(development)
        can %i[bulk_edit progresses], Phase, development_id: development.id
      end
    end

    def crud_finishes(developer_id)
      crud_class(Finish, developer_id)
      can :read, FinishType
      can :read, FinishCategory
      crud_class(FinishManufacturer, developer_id)
    end

    def crud_appliances(developer_id)
      crud_class(Appliance, developer_id)
      can :read, ApplianceCategory
      can :read, ApplianceManufacturer
    end

    # Generic ability for any class with a developer_id attribute that
    # needs to be distinct from Admin objects
    def crud_class(klass, developer_id)
      # Can read records developer_id is that of the developer trying to read
      can :read,
          klass,
          ["#{klass.table_name}.developer_id = ? OR " \
           "#{klass.table_name}.developer_id IS NULL", developer_id] \
           do |instance|
        instance.developer_id == developer_id || instance.developer_id.nil?
      end

      # Can only destroy or update an instance if the developer_id matches
      # the developer trying to delete
      can %i[destroy update], klass do |instance|
        instance.developer_id == developer_id
      end

      # Creates klass objects initialised with developer_id of the
      # logged in developer
      can :create, klass, developer_id: developer_id
      can :clone, klass, developer_id: nil
      can :clone, klass, developer_id: developer_id
    end

    # restrict unit types
    def crud_unit_types(development)
      can :create, UnitType, development_id: development.id
      # :read is defined at development level
      can %i[update destroy], UnitType, restricted: false
    end

    # restrict rooms
    # rubocop:disable Metrics/MethodLength
    def crud_rooms(development)
      can :read, Room, development_id: development.id

      can :create, Room, development_id: development.id,
                         plot: nil

      can %i[update destroy remove_finish remove_appliance],
          Room, development_id: development.id,
                unit_type: { restricted: false },
                plot: nil

      can :create_room_unittype, Room,
          development_id: development.id,
          unit_type: { restricted: false }

      can %i[create destroy], FinishRoom,
          room: { development_id: development.id,
                  unit_type: { restricted: false },
                  plot: nil }

      can %i[create destroy], ApplianceRoom,
          room: { development_id: development.id,
                  unit_type: { restricted: false },
                  plot: nil }
    end
    # rubocop:enable Metrics/MethodLength

    # restrict rooms in plots
    def crud_plot_rooms(development, phase)
      can :create, Room, development_id: development.id,
                         plot: { phase: { id: phase.id } }

      can :crud, PlotRoom do |plotroom|
        plotroom.development_id == development.id &&
          plotroom.phase_id == phase.id &&
          plotroom.completion_release_date.present? &&
          plotroom.completion_release_date <= Time.zone.today
      end
    end

    def crud_finish_rooms(development, phase)
      can %i[create destroy], FinishRoom,
          room: { development_id: development.id,
                  unit_type: { restricted: false },
                  plot: { phase_id: phase.id } }

      can %i[create destroy], FinishRoom,
          room: { development_id: development.id,
                  unit_type: nil,
                  plot: { phase_id: phase.id } }
    end

    def crud_appliance_rooms(development, phase)
      can %i[create destroy], ApplianceRoom,
          room: { development_id: development.id,
                  unit_type: { restricted: false },
                  plot: { phase_id: phase.id } }

      can %i[create destroy], ApplianceRoom,
          room: { development_id: development.id,
                  unit_type: nil,
                  plot: { phase_id: phase.id } }
    end

    def crud_plots(development)
      can %i[update_unit_type inform], Plot do |plot|
        plot.development_id == development.id &&
          plot.completion_release_date.present? &&
          plot.completion_release_date <= Time.zone.today
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
