module App
  ROOT = File.join(::ROOT, 'tmp/app')

  def open_file(file, mode)
    File.open(File.join(ROOT, file), mode) do |f|
      yield f
    end
  end
  module_function :open_file
end
