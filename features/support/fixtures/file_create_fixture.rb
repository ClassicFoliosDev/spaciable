# frozen_string_literal: true

module FileCreateFixture
  module_function

  def write_file(model_id, file_name)
    base_dir = ENV['BASE_PATH']

    tmp_file_path = if base_dir
      File.join(base_dir, "uploads", "document", "file", model_id.to_s)
                    else
      File.join("uploads", "document", "file", model_id.to_s)
                    end

    create_dirs(tmp_file_path)

    full_path = File.join(tmp_file_path, file_name)

    File.open(full_path, "a") do |f|
      f.write nil
    end
  end

  def create_dirs(path)
    unless File.directory?(path)
      FileUtils.mkdir_p(path)
    end
  end
end
