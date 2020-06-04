# frozen_string_literal: true

module Crms
  # rubocop:disable Metrics/ClassLength
  class Zoho < Crms::Root
    include ActiveModel::Model
    require "fileutils"

    require "ZCRMSDK"
    include HTTParty

    MODULE = {
      ::Development => { name: "Developments", view: "All Developments" },
      ::Phase => { name: "Plots", view: "All Plots" },
      ::Plot => { name: "Plots", view: "All Plots", ident: :number }
    }.freeze

    attr_accessor :record_name

    def initialize(parent)
      super

      @mod = MODULE[parent.class]
      ZCRMSDK::RestClient::ZCRMRestClient.init(config_details)
    end

    # Sync the docs for the parent
    def documents
      docs = []
      attachments&.each do |doc|
        docs << Crms::Root::Document.new(document_key: doc.id,
                                         record_key: record.entity_id,
                                         file_name: doc.file_name,
                                         updated_at: doc.modified_time,
                                         meta: identity)
      end

      rationalise!(docs)
    end

    # Zoho has 'modules' and these can be 'related' in the same way
    # any database has related objects.  e.g. the 'Plots' module
    # records have a related (parent) 'Developents' module. Retrieving
    # the plots for a development means asking for a 'Developments'
    # module record (matching the Spaciable development name) for its
    # related 'Plots'.  Then we can filter the (in this example) plots
    # by the supplied names, and then get their attachments
    def documents_for(parent, s_children, c_ident)
      docs = []

      # Get the matching z (zoho) and (s) spaciable records
      matching_records(parent, s_children, c_ident) do |_, s|
        Crms::Zoho.new(s).documents.each { |doc| docs << doc }
      end

      docs
    end

    # Get related plots for parent and return completion dates that
    # differ in zoho/spaciable
    def completion_dates(parent, s_plots)
      collection = PlotCollection.new

      # Get the matching z (zoho) and (s) spaciable records
      matching_records(parent, s_plots, :number) do |z, s|
        next unless z.field_data["Completion_Date"]

        z_completion_date = Date.parse(z.field_data["Completion_Date"])
        next unless z_completion_date != s.completion_date

        collection.plots << Crms::Root::Plot.new(id: s.id,
                                                 number: s.number,
                                                 completion_date: z_completion_date)
      end

      collection
    end

    # Get related plots for parent then residents for the plots
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def residents(parent, s_plots)
      collection = PlotCollection.new

      # Get the matching z (zoho) and (s) spaciable records
      matching_records(parent, s_plots, :number) do |_, s|
        residents = Crms::Zoho.new(s).related("Residents")

        next unless residents

        plot = Crms::Root::Plot.new(id: s.id, number: s.number)
        residents.each do |resident|
          plot.residents << Crms::Root::Resident.new(
            title: resident.field_data["Title"].downcase,
            first_name: resident.field_data["Name"],
            last_name: resident.field_data["LastName"],
            email: resident.field_data["Email"],
            phone_number: resident.field_data["Phone"]
          )
        end

        plot.rationalise

        collection.plots << plot if plot.residents.present?
      end

      collection
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    # download an individual document
    def download_doc(params)
      Crms::Document.transaction do
        # create a document record
        doc = Crms::Document.create(title: params[:display_name],
                                    file: params[:file_name],
                                    original_filename: params[:file_name],
                                    category: params[:category],
                                    user_id: RequestStore.store[:current_user].id,
                                    documentable_type: @parent.class,
                                    documentable_id: @parent.id,
                                    updated_at: params[:updated_at].to_datetime)

        download(Crms::Root::Document.new(params), doc.id)
      end
    end

    # get the records in the supplied list (module) that are related to 'this'
    # module record. Apply filter if one is supplied
    def related(list, filter: nil)
      rrecs = record.get_relatedlist_records(list).data
      return rrecs unless filter

      rrecs.select { |r| filter.include?(r.field_data["Name"]) }
    rescue ZCRMSDK::Utility::ZCRMException
      nil # standard empty list response
    end

    private

    # For the purposes of Zoho, a record's primary 'string' key is
    # assumed to be the 'Name' field.  In Spaciable, models don't
    # universally have a 'name' field.  Many use alternatives such
    # as 'number' or 'company_name'.  In order for us to match the
    # 'name' field and identify a matching Zoho record, we need to
    # see if an alternative 'ident' field has been configured and
    # then use that if necessary
    def identity
      @mod[:ident] ? @parent.send(@mod[:ident]) : parent.name
    end

    # Get the named Zoho module - e.g. Developments
    def zmodule(name)
      ZCRMSDK::Operations::ZCRMModule.get_instance(name)
    end

    # Zoho modules have custom views that filter the rows.  e.g.
    # 'My Developments' might show all developments
    def custom_view
      mod = zmodule(@mod[:name]) # get the module

      # Get all views and identify the one we're after
      view = mod.get_all_customviews
                .response_json["custom_views"]
                .find { |v| v["display_value"] == @mod[:view] }

      # return the view instance
      ZCRMSDK::Operations::ZCRMCustomView.get_instance(view["id"], @mod[:name])
    end

    # Get all records in the view
    def records
      return @records if @records

      @records = custom_view.get_records.data
    end

    # Return an individual record within the view within the module.
    # So return the 'identity' (e.g. development name) within the
    # view name (e.g. My Developments) within a module (e.g. Developments)
    def record
      return @record if @record

      @record = records.find { |r| r.field_data["Name"] == identity }
    end

    # Get all the attachments for the record
    def attachments
      record.get_attachments(1).data
    rescue ZCRMSDK::Utility::ZCRMException
      nil
    end

    # Dowwload and save a single attached document
    def download(document, id)
      record = ZCRMSDK::Operations::ZCRMRecord.get_instance(@mod[:name], document.record_key)
      res = record.download_attachment(document.document_key)
      path = FileUtils.mkdir_p "#{DOCS_FOLDER}/#{id}"
      filepath = "#{path[0]}/#{res.filename}"
      File.write(filepath, res.response.force_encoding("UTF-8"))
    end

    # Identify the parent (ie Developments) related records (ie Plots)
    # then yield matching Zoho and Spaciable records
    def matching_records(parent, s_children, c_ident)
      # get the identity field (ie name) from each Spaciable child
      identities = s_children.map { |a| a.send(c_ident) }
      # get the related records from the parent Zoho module record and filter
      # them for matches with only the required Spaciable records
      z_recs = Crms::Zoho.new(parent).related(@mod[:name], filter: identities)

      # go through each matching Zoho record
      z_recs.each do |zr|
        # get the matching Spaciable child
        child = s_children.find_by(c_ident => zr.field_data["Name"])
        next unless child

        yield zr, child
      end
    end

    # Set up the Zoho configuration from the parent crm record
    def config_details
      config = {}
      %i[client_id
         client_secret
         redirect_uri
         current_user_email
         accounts_url
         api_base_url
         token_persistence_path].each do |field|
        config[field.to_s] = @parent.crm.send(field)
      end
      config
    end
  end
end
# rubocop:enable Metrics/ClassLength
