# frozen_string_literal: true
module RoomFixture
  module_function

  def updated_room_name
    "Kitchen"
  end

  def finish_attrs
    {
      finish_category_id: "Flooring",
      finish_type_id: "Carpet",
      manufacturer_id: "Corma Carpets"
    }
  end

  def second_finish_attrs
    {
      finish_category_id: "Sanitaryware",
      finish_type_id: "Shower Unit",
      manufacturer_id: "Aqualisa"
    }
  end

  def not_present_attrs
    {
      finish_category_id: "Cabinet",
      finish_type_id: "Floor"
    }
  end
end
