# frozen_string_literal: true
class Document < ApplicationRecord
  mount_uploader :file, DocumentUploader

  belongs_to :documentable, polymorphic: true
  alias parent documentable
  include InheritParentPermissionIds
  include InheritPolymorphicParentPermissionIds

  belongs_to :developer, optional: false
  belongs_to :division, optional: true
  belongs_to :development, optional: true

  validates :title, presence: true, uniqueness: false

  def to_s
    title
  end

  def set_original_filename
    self.original_filename = file.filename
  end
end
