# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  belongs_to :userable, polymorphic: true

  scope :within_range,
        lambda { |params|
          where(eventable_type: params[:eventable_type],
                eventable_id: params[:eventable_id])
          .where("events.start <= ? AND ? <= events.end", params[:end], params[:start])
        }
end
