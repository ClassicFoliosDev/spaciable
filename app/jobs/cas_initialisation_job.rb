# frozen_string_literal: true

class CasInitialisationJob < ApplicationJob
  # initialse all the CAS data - errors go to Rollbar
  def perform(developer_id)
    Cas.initialise(developer_id)
  end
end
