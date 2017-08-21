# frozen_string_literal: true
class Document < ApplicationRecord
  mount_uploader :file, DocumentUploader
  process_in_background :file

  attr_accessor :notify

  belongs_to :documentable, polymorphic: true
  alias parent documentable
  include InheritParentPermissionIds
  include InheritPolymorphicParentPermissionIds

  belongs_to :developer, optional: false
  belongs_to :division, optional: true
  belongs_to :development, optional: true

  validates :title, presence: true, uniqueness: false

  enum category: [
    :my_home,
    :locality,
    :legal_and_warranty
  ]

  def to_s
    title
  end

  def set_original_filename
    self.original_filename = file.filename
  end
end
