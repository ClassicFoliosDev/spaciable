# frozen_string_literal: true

class SyncFaq
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :parent, :faqs

end
