# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent
class Choice < ApplicationRecord
  belongs_to :choiceable, polymorphic: true
  belongs_to :room_item, optional: false
  has_many :room_choices

  # delegte detail to choiceable
  delegate :full_name, to: :choiceable
  delegate :short_name, to: :choiceable
  delegate :appliance_category, to: :choiceable
  delegate :finish_category, to: :choiceable

  def name(fullname)
    fullname ? full_name : short_name
  end
end
# rubocop:enable Rails/HasManyOrHasOneDependent
