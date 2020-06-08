# frozen_string_literal: true

# Define a common interface for CRM functions
module Crms
  class Root
    include ActiveModel::Model

    DOCS_FOLDER = Rails.root.join("public", "uploads", "document", "file")

    class Document
      include ActiveModel::Model

      attr_accessor :record_key
      attr_accessor :document_key
      attr_accessor :file_name
      attr_accessor :display_name
      attr_accessor :category
      attr_accessor :updated_at
      attr_accessor :meta

      def initialize(params)
        if params[:document_key].nil? || params[:file_name].nil?
          raise "document_key/file_name must be specified"
        end

        @record_key = params[:record_key]
        @document_key = params[:document_key]
        @file_name = params[:file_name]
        @display_name = params[:display_name]
        @category = params[:category] || "my_home"
        @updated_at = params[:updated_at]&.to_time
        @meta = params[:meta]
      end
    end

    class Plot
      include ActiveModel::Model

      attr_accessor :id
      attr_accessor :number
      attr_accessor :completion_date

      def residents
        @residents ||= []
      end

      # delete residents with an existing Spaciable email
      def rationalise
        residents.delete_if { |r| ::Resident.where(email: r.email).present? }
      end

      def residents_attributes=(attributes)
        attributes.each { |a| residents << Resident.new(a[1]) }
      end

      def validates?
        valid? && residents.map(&:valid?)
      end

      def s_plot
        @s_plot ||= ::Plot.find(id)
      end
    end

    class PlotCollection
      include ActiveModel::Model

      def plots
        @plots ||= []
      end

      def plots_attributes=(attributes)
        attributes.each { |a| plots << Plot.new(a[1]) }
      end

      def validates?
        # Check all results are true
        (valid? && plots.map(&:validates?)).flatten.all? { |t| t }
      end
    end

    class Resident
      include ActiveModel::Model

      attr_accessor :title
      attr_accessor :first_name
      attr_accessor :last_name
      attr_accessor :email
      attr_accessor :phone_number
      attr_accessor :role

      def role
        @role ||= :homeowner
      end

      def attributes
        { "title" => title, "first_name" => first_name,
          "last_name" => last_name, "email" => email,
          "phone_number" => phone_number, "role" => role }
      end

      validates :first_name, :last_name, :email, :phone_number, presence: true
    end

    attr_accessor :parent

    def initialize(parent)
      @parent = parent
    end

    def documents
      no_implemenation_error __method__
    end

    def download_doc(_)
      no_implemenation_error __method__
    end

    private

    # Rationalise the documents against those retrieved
    # from the CRM.  Remove all documents where there is an exact
    # filename and updated_at match
    def rationalise!(documents)
      documents.delete_if do |d|
        parent.documents.where(original_filename: d.file_name,
                               updated_at: d.updated_at).present?
      end
    end

    def no_implemenation_error(method)
      raise "No implementation error - #{self.class}::#{method}"
    end
  end
end
