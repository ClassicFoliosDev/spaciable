# frozen_string_literal: true

class UnlatchSychDocJob < ApplicationJob
  queue_as :mailer

  def perform(plot_id, document_id)
    return if Plot.find(plot_id)&.phase&.unlatch_program_id.blank?
    UnlatchMailer.sync_docs(plot_id, document_id).deliver_now
  end
end
