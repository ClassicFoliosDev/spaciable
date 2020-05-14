# frozen_string_literal: true

# A Timeline has multiple Stages
# A Stage can be in multiple Timelines
class TimelineStage < ApplicationRecord
  self.table_name = "timeline_stages"

  belongs_to :timeline
  belongs_to :stage
end
