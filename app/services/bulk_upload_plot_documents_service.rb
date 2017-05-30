# frozen_string_literal: true
module BulkUploadPlotDocumentsService
  module_function

  def call(parent_plots, plot_document_params)
    category = plot_document_params[:category]
    raw_files = plot_document_params[:files]
    plots = parent_plots.map { |plot| [plot.to_s.downcase.strip, plot] }
    files = raw_files.map do |file|
      [file.original_filename.downcase.strip, file]
    end

    matches, unmatched = find_matches(files, plots)
    saved, _errors = save_matches(matches, category)

    [saved, unmatched]
  end

  private

  module_function

  def find_matches(files, plots)
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

    [matched, unmatched]
  end

  def compare_names(plots, file_name)
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
      return plot[1] if matched
    end

    false
  end

  def save_matches(matches, category)
    saved = []
    errors = []

    matches.each do |(plot, file)|
      doc = plot.documents.build(file: file, title: file.original_filename, category: category)

      if doc.save then saved << doc
      else errors << doc.errors.full_messages
      end
    end

    [saved, errors.flatten!]
  end
end
