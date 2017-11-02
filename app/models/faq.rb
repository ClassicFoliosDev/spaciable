# frozen_string_literal: true

class Faq < ApplicationRecord
  belongs_to :developer, optional: false
  belongs_to :division, optional: true
  belongs_to :development, optional: true
  belongs_to :faqable, polymorphic: true

  attr_accessor :notify

  alias parent faqable
  include InheritParentPermissionIds
  include InheritPolymorphicParentPermissionIds

  enum category: %i[settling home troubleshooting urgent general]

  validates :question, :answer, :category, :faqable, presence: true

  delegate :to_s, to: :question
end
