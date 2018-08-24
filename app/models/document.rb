# frozen_string_literal: true

class Document < ApplicationRecord
  mount_uploader :file, DocumentUploader

  attr_accessor :notify

  belongs_to :documentable, polymorphic: true
  belongs_to :user, optional: true
  has_many :plot_documents, dependent: :destroy
  alias parent documentable

  validates :title, presence: true, uniqueness: false
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
    save!
  end

  def shared?(plot)
    plot_document = plot_documents.find_by(plot_id: plot.id)
    return false unless plot_document

    plot_document.enable_tenant_read
  end
end
