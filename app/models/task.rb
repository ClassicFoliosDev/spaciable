# frozen_string_literal: true

# A task is the main component of a Timeline. it provides all the
# detail.  A Task can be shared amongst different Timelines
class Task < ApplicationRecord
  has_many :actions
  has_many :task_shortcuts, inverse_of: :task
  has_many :shortcuts, through: :task_shortcuts
end
