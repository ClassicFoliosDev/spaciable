# frozen_string_literal: true

class SnagComment < ApplicationRecord
  mount_uploader :image, PictureUploader
  belongs_to :snag, optional: false
  has_one :plot, through: :snag
  validates :content, presence: true
  belongs_to :commenter, polymorphic: true

  delegate :plot_id, to: :snag
  delegate :title, to: :snag, prefix: true
  delegate :first_name, to: :commenter
  delegate :last_name, to: :commenter

  def commenter_name
    return commenter.role if commenter.first_name.blank?
    commenter.first_name + " " + commenter.last_name + " " + "(" + commenter_permission + ")"
  end

  def commenter_permission
    if commenter_type == "Resident"
      commenter_type
    else
      commenter.permission_level.to_s
    end
  end
end
