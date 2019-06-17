# frozen_string_literal: true

class Snag < ApplicationRecord
  belongs_to :plot
  has_many :plots, through: :plot_snags
  has_one :development, through: :plot
  has_one :phase, through: :plot

  delegate :snag_name, to: :development

  has_many :snag_comments, dependent: :destroy

  has_many :snag_attachments, dependent: :destroy
  accepts_nested_attributes_for :snag_attachments, allow_destroy: true

  validates :title, presence: true
  validates :description, presence: true

  validates_associated :snag_attachments

  def resolved_visual
    visual_status = if approved?
                      "green"
                    elsif awaiting?
                      "amber"
                    else
                      "red"
                    end
    visual_status
  end

  enum status: { unresolved: 0, awaiting: 1, rejected: 2, approved: 3 }

  def resolved_status
    I18n.t("admin.snags.show.#{status}")
  end

  def user_name(current_user)
    current_user.to_s + " (" + current_user.permission_level.to_s + ")"
  end

  def self.plot_phase(params)
    plot = Plot.find_by id: params
    plot.phase_id
  end

  def comments
    snag_comments.order(created_at: :desc)
  end

  # When a snag fails validation part way through a creation, it
  # needs metadata clearing out otherwise Ruby can missidentify
  # it as an update to a (failed to save) exisitng snag
  def clear
    snag_attachments.delete_all
    self.id = nil
  end
end
