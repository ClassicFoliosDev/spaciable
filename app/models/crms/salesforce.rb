# frozen_string_literal: true

module Crms
  # rubocop:disable Metrics/ClassLength
  class Salesforce < Crms::Root
    include ActiveModel::Model
    include HTTParty

    require "fileutils"
    require "tempfile"
    require "restforce"

    attr_accessor :client
    attr_accessor :developer
    attr_accessor :development

    class AuthorizationError < StandardError; end

    def initialize(parent)
      super
    end

    # Sync the docs for the parent
    def documents
      docs = []
      attachments&.each do |doc|
        filename = "#{doc['Title']}.#{doc['FileType'].downcase}"
        # need to check dates too in live edition, and implement
        # 'update' functionality to replace an updatred file version
        next if @parent.documents.find_by(original_filename: filename)

        docs << Crms::Root::Document.new(document_key: doc["ContentDocumentId"],
                                         record_key: doc["VersionData"],
                                         file_name: "#{doc['Title']}.#{doc['FileType'].downcase}",
                                         updated_at: Date.parse(doc["LastModifiedDate"]),
                                         meta: @parent.identity)
      end

      rationalise!(docs)
    end

    def documents_for(_, s_plots, _)
      docs = []

      # Get the matching saleforce (sf) and (sp) spaciable plots
      matching_plots(s_plots) do |_, sp|
        Crms::Salesforce.new(sp).documents&.each { |doc| docs << doc }
      end

      docs
    end

    # Get plots for parent development then residents for plots
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def residents(_, s_plots)
      return PlotCollection.new unless development

      collection = PlotCollection.new
      matching_plots(s_plots) do |sfp, sp|
        plot = Crms::Root::Plot.new(id: sp.id, number: sp.number)
        plot_residents(sfp)&.each do |resident|
          # ignore if already resident
          next if sp.residents.find_by(email: resident.Email__c)

          plot.residents << Crms::Root::Resident.new(
            title: resident.Title__r.Name.downcase,
            first_name: resident.Name,
            last_name: resident.Last_Name__c,
            email: resident.Email__c,
            phone_number: resident.Phone__c
          )
        end

        collection.plots << plot if plot.residents.present?
      end

      collection
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    # download an individual document
    def download_doc(params)
      file = nil
      ::Document.transaction do
        # create a document record
        file = download(params) # download to /tmp
        doc = ::Document.new(file: file,
                             title: params[:display_name],
                             original_filename: params[:file_name],
                             category: params[:category],
                             user_id: RequestStore.store[:current_user].id,
                             documentable: @parent,
                             updated_at: params[:updated_at].to_datetime)
        doc.save! # save will copy file from tmp to file/aws storage
      end
    ensure
      file&.tempfile&.unlink if file
    end

    # Get plots for development and return completion dates that
    # differ in salesforce/spaciable
    def completion_dates(_, s_plots)
      collection = PlotCollection.new

      # Get the matching sfp (salesforce) and (sp) spaciable records
      matching_plots(s_plots) do |sfp, sp|
        next unless sfp.Completion_Date__c

        sf_completion_date = Date.parse(sfp.Completion_Date__c)
        next unless sf_completion_date != sp.completion_date

        collection.plots << Crms::Root::Plot.new(id: sp.id,
                                                 number: sp.number,
                                                 completion_date: sf_completion_date)
      end

      collection
    end

    def client
      @client ||= Restforce.new(oauth_token: crm.token,
                                refresh_token: crm.refresh_token,
                                instance_url: crm.api_base_url,
                                client_id: crm.client_id,
                                client_secret: crm.client_secret,
                                authentication_callback: proc { |new_token|
                                  access_token = crm.access_token
                                  access_token.access_token = new_token["access_token"]
                                  access_token.save!
                                },
                                api_version: "41.0")
    end

    private

    def s_developer
      if @parent.is_a? Developer
        @parent
      else
        @parent.developer
      end
    end

    def s_development
      if @parent.is_a? Development
        @parent
      else
        @parent.development
      end
    end

    def s_plot
      return unless @parent.is_a? ::Plot

      @parent
    end

    def developer
      return @developer if @developer

      devs = client.query("select Id from Developer__c where Name = '#{s_developer.identity}'")
      return nil unless devs.count == 1

      @developer = devs.first.Id
    end

    def development
      return unless developer
      return @development if @development

      devs = client.query("select Id,Name from Development__c where Developer__c = " \
                          "'#{developer}' and Name = '#{s_development.identity}'")
      return nil unless devs.count == 1

      @development = devs.first.Id
    end

    def plot
      return unless development
      return @plot if @plot

      plots = client.query("select Id,Name from Plot__c where Development__c = " \
                          "'#{development}' and Name = '#{s_plot.identity}'")
      return nil unless plots.count == 1

      @plot = plots.first.Id
    end

    def plot_residents(sf_plot)
      client.query("SELECT Title__r.name,Name,Last_name__c,Email__c,Phone__c " \
                   "from Resident__c where Plot__c = '#{sf_plot.Id}'")
    end

    # Identify matching plots numbers for the Salesforce
    # and Spaciable records
    def matching_plots(s_plots)
      return unless development

      # get the salesforce plots for the development
      sf_plots = client.query("select Id,Name,Completion_Date__c from Plot__c "\
                              "where Development__c = '#{development}'")

      # go through each Saleforce plot
      sf_plots&.each do |sfp|
        # match with a Spaciable plot
        child = s_plots.find_by(number: sfp.Name)
        next unless child

        yield sfp, child
      end
    end

    # Get the attachments for the @parent
    # rubocop:disable Metrics/MethodLength
    def attachments
      docs = []
      return unless @parent.is_a?(Development) || @parent.is_a?(::Plot)

      # retrieve document links
      links = post(query("SELECT+id,LinkedEntityId,ContentDocumentId+" \
                         "FROM+ContentDocumentLink+" \
                         "WHERE+LinkedEntityId='#{send(@parent.class.to_s.downcase)}'"))
      return unless links

      # go through the document links and get the version data
      links["records"].map { |doc| doc["ContentDocumentId"] }.each do |id|
        cv = post(query("SELECT+VersionData,ContentDocumentId,title,filetype,LastModifiedDate+" \
                        "FROM+ContentVersion+" \
                        "WHERE+ContentDocumentId='#{id}'+and+IsLatest = true"))
        next unless cv["totalSize"] == 1

        docs << cv["records"][0]
      end

      docs
    rescue
      nil
    end
    # rubocop:enable Metrics/MethodLength

    # Download document to /tmp an give it a random filename
    def download(params)
      res = post("#{crm.api_base_url}#{params[:record_key]}")

      # Create a tempfile - this generates a unique temp name
      temp = Tempfile.new([params[:file_name], File.extname(params[:file_name])])
      temp.write(res.force_encoding("UTF-8"))
      temp.close

      # Uploaded file ensures temp file name converts to original filename
      file = ActionDispatch::Http::UploadedFile.new(tempfile: temp)
      file.original_filename = params[:file_name]
      file
    end

    def query(soql)
      "#{crm.api_base_url}/services/data/v43.0/query?q=#{soql}"
    end

    def post(url)
      retries ||= 0
      response =
        HTTParty.post(url,
                      headers:
                      {
                        "Authorization" => "Bearer #{crm.token}"
                      })

      raise AuthorizationError if response.code == 401 # retry once

      response.parsed_response
    rescue AuthorizationError
      # asking for the developer again through the client is the
      # easiest way to reset the access_token
      @developer = nil
      developer
      retry if (retries += 1) <= 1
    end
  end
  # rubocop:enable Metrics/ClassLength
end
