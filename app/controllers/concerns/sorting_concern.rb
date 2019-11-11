# frozen_string_literal: true

module SortingConcern
  extend ActiveSupport::Concern

  def sort(resources, default: :updated_at)
    return resources if resources&.empty?

    direction = params[:direction]
    if custom_sort?(resources, params, default, "plots", "number")
      sort_plot_numbers(resources, direction)
    elsif custom_sort?(resources, params, default, "appliances", "id")
      sort_appliances(resources, direction)
    elsif direction.present? && params[:sort].present?
      sort_resources(resources, params)
    else
      resources&.order(default)
    end
  end

  private

  def custom_sort?(resources, params, default, table_name, sort_on)
    return false unless resources&.table_name == table_name
    return true if params[:sort] == sort_on
    return true if params[:sort].nil? && default.to_s == sort_on
    false
  end

  def sort_resources(resources, params)
    direction = params[:direction] == "desc" ? :desc : :asc

    sort_on_column(resources, params[:sort], params[:sort_on], direction)
  end

  def sort_on_column(resources, column, sort_on, direction)
    return resources.order(column => direction) if sort_on.blank?

    association = resources.first.association(sort_on).klass
    association_order = association.order(column => direction)

    resources
      .joins(sort_on.to_sym)
      .merge(association_order)
  end

  def sort_plot_numbers(resources, direction)
    plot_array = resources.sort

    @numbers = plot_array.map(&:number)
    @ids = plot_array.map(&:id)
    @unsorted_numbers = []

    # Alphanumeric sort can't cope with spaces and special characters, process them separately
    filter_special_characters

    @sorted_numbers = sort_mixed_alphanumeric
    insert_unsorted_elements

    @sorted_numbers = @sorted_numbers.reverse if direction == "desc"
    sort_plots
  end

  def insert_unsorted_elements
    @unsorted_numbers.each do |unsorted|
      # Look for the index of the first non-numeric character (ie the first alphabetic letter)
      first_letter_index = unsorted =~ /\D/

      # If we found a letter after position zero, that means the first character is a digit,
      # for example it might be 7C, use the bsearch_index against the integer value (which
      # will be 7 in our example)
      if first_letter_index.positive?
        insert_at = @sorted_numbers.bsearch_index { |element| element.to_i >= unsorted.to_i }

      # First character is a letter, for example A3, so strip digits (result: A) before comparing
      else
        @sorted_numbers.each_with_index do |element, index|
          next if element =~ /^[0-9].*/
          break unless (unsorted <=> element).positive?
          insert_at = index + 1
        end
      end
      @sorted_numbers.insert(insert_at || 0, unsorted)
    end
  end

  def sort_mixed_alphanumeric
    @numbers.sort_by do |element|
      number, letter = *element.split
      [number.to_i, letter]
    end
  end

  def filter_special_characters
    special = "?<>',?[]}{=-)(*&^%$#`~{} "
    regex = /[#{special.gsub(/./) { |char| "\\#{char}" }}]/

    @numbers.each do |element|
      if element =~ regex
        @unsorted_numbers << element
      elsif element.chr =~ /[A-Za-z]/
        @unsorted_numbers << element
      end
    end

    @numbers -= @unsorted_numbers
  end

  def sort_plots
    sorted_number_string = @sorted_numbers.join(",") + ","
    Plot.where(id: @ids).order("position(','||number::text||',' in '#{sorted_number_string}')")
  end

  def sort_appliances(resources, direction)
    resources.order("appliance_manufacturers.name #{direction}, model_num #{direction}")
  end
end
