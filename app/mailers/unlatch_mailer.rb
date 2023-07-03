# frozen_string_literal: true

class UnlatchMailer < ApplicationMailer
  default from: "no_reply@spaciable.com"
  defult to: "unlatch@spaciable.com"

  def sync_docs(plot_id, document_id)
    @plot = Plot.find(plot_id)
    @document = Document.find(document_id)

    mail to: email, subject: "poop"
  end
end
