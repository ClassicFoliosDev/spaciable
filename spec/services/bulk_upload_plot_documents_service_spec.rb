# frozen_string_literal: true
require "rails_helper"

RSpec.describe BulkUploadPlotDocumentsService do
  describe "#find_matches" do
    let(:developer) { create(:developer) }
    let(:unit_type) { create(:unit_type) }
    let(:plot1) { create(:plot, unit_type: unit_type, prefix: "Plot", number: "1") }
    let(:plot120) { create(:plot, unit_type: unit_type, prefix: "Plot", number: "1.20") }
    let(:plot176) { create(:plot, unit_type: unit_type, prefix: "Plot", number: "1.7.6") }
    let(:plot1a) { create(:plot, unit_type: unit_type, prefix: "Plot", number: "1a") }

    context "with a matching file id" do
      it "should match a plot with a file of the same name" do
        file1 = create(:document,
                       title: "Document title",
                       original_filename: "plot 1 homeowner doc.pdf",
                       developer: developer)
        file1a = create(:document,
                        title: "Document title",
                        original_filename: "plot 1a homeowner doc.pdf",
                        developer: developer)
        file176 = create(:document,
                         title: "Document title",
                         original_filename: "plot 1.7.6 homeowner doc.pdf",
                         developer: developer)
        file120 = create(:document,
                         title: "Document title",
                         original_filename: "plot 1.20.pdf",
                         developer: developer)

        raw_files = []
        raw_files.push(file1, file1a, file176, file120)

        files = raw_files.map do |file|
          [file.original_filename.downcase.strip, file]
        end

        raw_plots = []
        raw_plots.push(plot1, plot120, plot176, plot1a)
        plots = raw_plots.map { |plot| [plot.to_s.downcase.strip, plot] }

        response = subject.find_matches(files, plots)

        expect(response[1]).to be_empty
        expect(response[0].length).to eq(4)

        response[0].each_with_index do |match, index|
          expect(match[1].original_filename).to eq(raw_files[index].original_filename)
        end
      end
    end

    context "with a non matching file id" do
      it "should not match a plot with a file of a different name" do
        file2 = create(:document,
                       title: "Document title",
                       original_filename: "plot 2 homeowner doc.pdf",
                       developer: developer)

        raw_files = []
        raw_files.push(file2)

        files = raw_files.map do |file|
          [file.original_filename.downcase.strip, file]
        end

        raw_plots = []
        raw_plots.push(plot1)
        plots = raw_plots.map { |plot| [plot.to_s.downcase.strip, plot] }

        response = subject.find_matches(files, plots)

        expect(response[0]).to be_empty
        expect(response[1]).to include(file2.original_filename)
      end
    end

    context "with a partially matching file id" do
      it "should not match a plot with a file of a similar name" do
        file1b = create(:document,
                        title: "Document title",
                        original_filename: "plot 1b homeowner doc.pdf",
                        developer: developer)
        file12 = create(:document,
                        title: "Document title",
                        original_filename: "plot 1.2 homeowner doc.pdf",
                        developer: developer)
        file120 = create(:document,
                         title: "Document title",
                         original_filename: "1.20 homeowner doc.pdf",
                         developer: developer)

        raw_files = []
        raw_files.push(file1b, file12, file120)

        files = raw_files.map do |file|
          [file.original_filename.downcase.strip, file]
        end

        raw_plots = []
        raw_plots.push(plot1, plot1a, plot120)
        plots = raw_plots.map { |plot| [plot.to_s.downcase.strip, plot] }

        response = subject.find_matches(files, plots)

        expect(response[0]).to be_empty
        expect(response[1]).to include(file1b.original_filename)
        expect(response[1]).to include(file12.original_filename)
        expect(response[1]).to include(file120.original_filename)
      end
    end

    context "with no plot prefix" do
      it "still matches plot numbers correctly" do
        file1b = create(:document,
                        title: "Document title",
                        original_filename: "1b homeowner doc.pdf",
                        developer: developer)
        file12 = create(:document,
                        title: "Document title",
                        original_filename: "1.2 homeowner doc.pdf",
                        developer: developer)
        file120 = create(:document,
                         title: "Document title",
                         original_filename: "1.20 homeowner doc.pdf",
                         developer: developer)
        raw_files = []
        raw_files.push(file1b, file12, file120)

        files = raw_files.map do |file|
          [file.original_filename.downcase.strip, file]
        end

        noplot1b = create(:plot, unit_type: unit_type, prefix: "", number: "1b")
        noplot12 = create(:plot, unit_type: unit_type, prefix: "", number: "1.2")
        noplot1 = create(:plot, unit_type: unit_type, prefix: "", number: "1")
        raw_plots = []
        raw_plots.push(noplot1, noplot1b, noplot12)
        plots = raw_plots.map { |plot| [plot.to_s.downcase.strip, plot] }

        response = subject.find_matches(files, plots)

        expect(response[0].length).to eq(2)

        response[0].each_with_index do |match, index|
          expect(match[1].original_filename).to eq(raw_files[index].original_filename)
        end
        expect(response[1]).to include(file120.original_filename)
      end
    end

    context "with valid file rename" do
      it "replaces the document title" do
        file1 = create(:document,
                       title: "Document title",
                       original_filename: "plot 1 homeowner doc.pdf",
                       developer: developer)
        file1a = create(:document,
                        title: "Document title",
                        original_filename: "plot 1a homeowner doc.pdf",
                        developer: developer)
        file176 = create(:document,
                         title: "Document title",
                         original_filename: "plot 1.7.6 homeowner doc.pdf",
                         developer: developer)
        file120 = create(:document,
                         title: "Document title",
                         original_filename: "plot 1.20.pdf",
                         developer: developer)

        raw_files = []
        raw_files.push(file1, file1a, file176, file120)

        files = raw_files.map do |file|
          [file.original_filename.downcase.strip, file]
        end

        raw_plots = []
        raw_plots.push(plot1, plot120, plot176, plot1a)
        plots = raw_plots.map { |plot| [plot.to_s.downcase.strip, plot] }

        match_results = subject.find_matches(files, plots)

        rename_text = "Rename test"
        response = subject.save_matches(match_results[0], :legal_and_warranty, true, rename_text)

        expect(response[0][0].title).to eq rename_text
        expect(response[0][1].title).to eq rename_text
        expect(response[0][2].title).to eq rename_text
        expect(response[0][3].title).to eq rename_text
      end
    end

    context "with blank file rename" do
      it "generates an error" do
        file1 = create(:document,
                       title: "Document title",
                       original_filename: "plot 1 homeowner doc.pdf",
                       developer: developer)
        file1a = create(:document,
                        title: "Document title",
                        original_filename: "plot 1a homeowner doc.pdf",
                        developer: developer)
        raw_files = []
        raw_files.push(file1, file1a)

        raw_plots = []
        raw_plots.push(plot1)
        plots = raw_plots.map { |plot| [plot.to_s.downcase.strip, plot] }

        plot_document_params = {}
        plot_document_params[:category] = :legal_and_warranty
        plot_document_params[:files] = raw_files

        params = {}
        params[:commit] = I18n.t("plot_documents.form.upload_rename")
        rename_text = ""
        params[:rename_text] = rename_text

        response = subject.call(plots, plot_document_params, params)

        expect(response[0]).to be_empty
        expect(response[1]).to be_empty
        expect(response[2]).to eq(I18n.t("plot_documents.bulk_upload.no_rename_text"))
      end
    end
  end
end
