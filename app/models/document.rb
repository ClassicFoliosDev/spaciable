# frozen_string_literal: true

class Document < ApplicationRecord
  mount_uploader :file, DocumentUploader

  attr_accessor :notify, :files

  belongs_to :documentable, polymorphic: true
  belongs_to :user, optional: true
  has_many :plot_documents, dependent: :destroy
  alias parent documentable

  validates :file, presence: true

  enum category: %i[
    my_home
    locality
    legal_and_warranty
  ]

  def to_s
    title
  end

  def set_original_filename
    self.original_filename = file.filename

    return if title.present?
    self.title = file&.filename&.humanize
  end

  def shared?(plot)
    plot_document = plot_documents.find_by(plot_id: plot.id)
    return false unless plot_document

    plot_document.enable_tenant_read
  end
end
