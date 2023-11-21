# frozen_string_literal: true

class Document < ApplicationRecord
  include CategoryEnum
  include GuideEnum

  mount_uploader :file, DocumentUploader

  attr_accessor :notify, :files

  after_create :update_laus
  after_update :update_laus
  after_create :sync_with_unlatch
  after_update :sync_with_unlatch
  belongs_to :documentable, polymorphic: true
  delegate :lots, to: :documentable
  belongs_to :user, optional: true
  belongs_to :custom_tile, optional: true
  has_many :plot_documents, dependent: :destroy
  alias parent documentable
  delegate :unlatch_developer, to: :parent
  has_many :unlatch_documents, class_name: "Unlatch::Document", dependent: :destroy
  validates :file, presence: true
  validates :guide, uniqueness: { scope: :documentable }, if: -> { guide.present? }
  delegate :expired?, to: :parent
  delegate :partially_expired?, to: :parent
  delegate :construction, :construction_name, to: :parent

  scope :of_cat_visible_on_plot,
        lambda { |ability, category, plot|
          documents = Document.accessible_by(ability).where(category: category)

          if plot.free?
            documents = documents.where(documentable_type: "Phase")
                                 .or(documents.where(override: true))
          end

          if plot.expiry_date.present?
            documents = documents.where("created_at <= ?", plot.expiry_date)
          end

          documents
        }

  def section
    documentable.section(self)
  end

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
    return unless saved_change_to_lau_visible? || saved_change_to_id?

    documentable&.plots&.each do |plot|
      if lau_visible
        pd = PlotDocument.find_by(plot_id: plot.id, document_id: id)
        if pd
          pd.update(enable_tenant_read: true)
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

  def read_only?
    res_comp? && !RequestStore.store[:current_user].cf_admin?
  end

  def sync_with_unlatch
    return if unlatch_developer.blank?

    if documentable.sync_to_unlatch?
      Unlatch::Document.sync(self)
    else
      unlatch_documents.destroy_all
    end
  end

  def unlatch_deep_sync
    sync_with_unlatch
  end

  def paired_with_unlatch?
    !unlatch_documents.empty?
  end

  delegate :linked_to_unlatch?, to: :documentable

  # rubocop:disable Style/IfUnlessModifier
  def source
    unless Rails.env.development?
      file.download!(file.url)
    end

    File.open(file.current_path)
  end
  # rubocop:enable Style/IfUnlessModifier
end
