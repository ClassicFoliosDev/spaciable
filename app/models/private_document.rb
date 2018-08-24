# frozen_string_literal: true

class PrivateDocument < ApplicationRecord
  mount_uploader :file, MultiUploader

  belongs_to :resident
  has_many :plot_private_documents, dependent: :destroy

  def to_s
    title
  end

  def shared?(plot)
    plot_private_document = plot_private_documents.find_by(plot_id: plot.id)
    return false unless plot_private_document

    plot_private_document.enable_tenant_read
  end
end
