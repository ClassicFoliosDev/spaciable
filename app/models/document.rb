# frozen_string_literal: true

class Document < ApplicationRecord
  include CategoryEnum
  include GuideEnum

  mount_uploader :file, DocumentUploader

  attr_accessor :notify, :files

  after_create :update_laus
  after_update :update_laus

  belongs_to :documentable, polymorphic: true
  belongs_to :user, optional: true
  belongs_to :custom_tile, optional: true

  has_many :plot_documents, dependent: :destroy
  alias parent documentable

  validates :file, presence: true
  validates :guide, uniqueness: { scope: :documentable }, if: -> { guide.present? }

  delegate :expired?, to: :parent
  delegate :partially_expired?, to: :parent

  delegate :construction, :construction_name, to: :parent

  def to_s
    title
  end

  def set_original_filename
    self.original_filename = file.filename

    return if title.present?

    new_title = File.basename(file.filename, File.extname(file.filename))
    self.title = new_title.tr("_", " ")
  end

  def shared?(plot)
    plot_document = plot_documents.find_by(plot_id: plot.id)
    return false unless plot_document

    plot_document.enable_tenant_read
  end

  def user_role(current_user)
    if current_user.cf_admin?
      user
    else
      user&.role == "cf_admin" ? I18n.t("documents.spaciable_admin") : user
    end
  end

  def construction_type
    # Developers and divisions will not have a construction type as they are
    # parents of development; if a document does not have a parent set
    # then no construction type can be determined
    return I18n.t("construction_type.home") if parent.nil? ||
                                               (parent.is_a?(Developer) ||
                                                parent.is_a?(Division)) ||
                                               construction == "residential"

    construction_name
  end

  def update_laus
    return unless lau_visible_changed? || id_changed?

    documentable&.plots&.each do |plot|
      if lau_visible
        pd = PlotDocument.find_by(plot_id: plot.id, document_id: id)
        if pd
          pd.update_attributes(enable_tenant_read: true)
        else
          PlotDocument.create(plot_id: plot.id, document_id: id,
                              enable_tenant_read: true)
        end
      else
        PlotDocument.find_by(plot_id: plot.id, document_id: id)&.destroy
      end
    end
  end

  def res_comp?
    reservation? || completion?
  end
end
