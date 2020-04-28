# frozen_string_literal: true

# A task is the main component of a Timeline. it provides all the
# detail.  A Task can be shared amongst different Timelines
class Task < ApplicationRecord
  include CalloutTypeEnum
  has_many :callouts

  attr_accessor :actions
  attr_accessor :features

  # Get the :action actions
  def actions
    callouts.where(callout_type: :action)
  end

  # Get the first action
  def action
    actions&.first
  end

  # Get the :feature actions
  def features
    callouts.where(callout_type: :feature)
  end

  # Get the first feature
  def feature
    features&.first
  end

  def update_from(params)
    update(params[:task])
    update_callouts(params)
  end

  def update_callouts(params)
    callouts.destroy_all
    Callout.callout_types.each do |name,_|
      if params[name]
        callout = Callout.new(params[name].merge(callout_type: name))
        callouts.create(callout.attributes) if callout.populated?
      end
    end
  end
end
