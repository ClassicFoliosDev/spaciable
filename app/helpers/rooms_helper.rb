# frozen_string_literal: true

module RoomsHelper
  def icon_names_collection
    Room.icon_names.map do |(icon_name, _icon_name_int)|
      [t(icon_name, scope: icon_name_scope), icon_name]
    end
  end

  def icon_file_name(icon_name)
    return unless icon_name
    _icon_file_name = "icon_#{icon_name}.svg"
  end

  private

  def icon_name_scope
    "activerecord.attributes.room.icon_names"
  end
end
