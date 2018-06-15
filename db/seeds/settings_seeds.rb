
if Setting.none?
  STDOUT.puts <<-INFO
    Creating ISYT? global configuration
  INFO

  Setting.create()
end
