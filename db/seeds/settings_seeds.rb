
if Setting.none?
  STDOUT.puts <<-INFO
    Creating Hoozzi global configuration
  INFO

  Setting.create()
end
