# frozen_string_literal: true

# A Tasklog records a positive/negative reponse to a
# Timeline_Task on a Plot_Timeline
class TaskLog < ApplicationRecord
  belongs_to :plot_timeline
  has_one :task

  enum response: %i[
    positive
    negative
  ]
end
