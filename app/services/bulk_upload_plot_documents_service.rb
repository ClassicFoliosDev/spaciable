# frozen_string_literal: true

module BulkUploadPlotDocumentsService
  module_function

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable MethodLength
  def call(parent_plots, plot_document_params, params)
    Rails.logger
         .debug(">> Bulk upload plot document service call START #{Time.zone.now}")

    category = plot_document_params[:category]
    pinned = plot_document_params[:pinned]
    guide = plot_document_params[:guide]
    raw_files = plot_document_params[:files]

    rename, rename_text = rename_params(params)
    if rename && rename_text.blank?
      return [[], [], I18n.t("plot_documents.bulk_upload.no_rename_text")]
    end

    plots = parent_plots.map { |plot| [plot.to_s.downcase.strip, plot] }
    files = raw_files.map do |file|
      [file.original_filename.downcase.strip, file]
    end

    matches, unmatched = find_matches(files, plots)
    saved, _errors = save_matches(matches, category, rename, rename_text, pinned, guide)

    Rails.logger
         .debug("<< Bulk upload plot document service call END #{Time.zone.now}")
    [saved, unmatched, nil]
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable MethodLength

  private

  module_function

  def find_matches(files, plots)
    Rails.logger.debug(">>> Bulk upload plot document service find matches start #{Time.zone.now}")
    unmatched = []

    matched = files.each_with_object([]) do |(filename, file), acc|
      matched_plot = compare_names(plots, filename)

      if matched_plot
        plot_obj = matched_plot
        acc << [plot_obj, file]
      else
        unmatched << file.original_filename
      end
      acc
    end

    Rails.logger.debug("<<< Bulk upload plot document service find matches end #{Time.zone.now}")
    [matched, unmatched]
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable MethodLength
  def compare_names(plots, file_name)
    Rails.logger
         .debug(">>> Bulk upload plot document service compare names start #{Time.zone.now}")
    file_extension = "." + file_name.split(".").last
    file_name = file_name.sub(file_extension, "")

    plots.each do |plot|
      return plot[1] if plot[0] == file_name

      next unless file_name.include?(plot[0])
      file_name_parts = file_name.split(" ")
      plot_name_parts = plot[0].split(" ")

      # Test all the segments from the plot name for a match
      # Additional segments in the file name are supported, they are ignored for matching purposes
      matched = true
      plot_name_parts.each_with_index do |plot_name_part, index|
        matched = false unless file_name_parts[index] == plot_name_part
      end

      debug_str = "<<< Bulk upload plot document service compare names matched"
      debug_str += "#{matched} #{Time.zone.now}"
      Rails.logger.debug(debug_str)
      return plot[1] if matched
    end

    debug_str = "<<< Bulk upload plot document service compare names matched"
    debug_str += "false #{Time.zone.now}"
    Rails.logger.debug(debug_str)

    false
  end
  # rubocop:enable MethodLength
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable MethodLength
  # rubocop:disable Metrics/ParameterLists
  def save_matches(matches, category, rename, rename_text, pinned, guide)
    Rails.logger
         .debug(">>> Bulk upload plot document service save matches start #{Time.zone.now}")
    saved = []
    errors = []

    matches.each do |(plot, file)|
      title = file.original_filename
      title = rename_text if rename
      doc = plot.documents.build(file: file, title: title, category: category,
                                 pinned: pinned, guide: guide)

      if doc.save then saved << doc
      else errors << doc.errors.full_messages
      end
    end

    Rails.logger
         .debug("<<< Bulk upload plot document service save matches end #{Time.zone.now}")

    [saved, errors.flatten!]
  end
  # rubocop:enable Metrics/ParameterLists
  # rubocop:enable MethodLength

  def rename_params(params)
    rename = params[:commit] == I18n.t("plot_documents.form.upload_rename")
    rename_text = params[:rename_text]

    [rename, rename_text]
  end
end
