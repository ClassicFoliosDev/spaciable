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
      matched_plot = plots.detect { |(plot_name, _)| filename.include? plot_name }

      if matched_plot
        plot_obj = matched_plot.last
        acc << [plot_obj, file]
      else
        unmatched << file.original_filename
      end
      acc
    end

    [matched, unmatched]
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
