require 'optparse'

options = {
    :extra_arguments => []
}
OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on("-p v", "--path v", "Feature path") do |v|
    options[:path] = v
  end

  opts.on("--features x,y,z",Array,"Features") do |f|
    options[:features] = f
  end

  opts.on("--args x,y,z",Array,"Arguments passed to cucumber") do |args|
    options[:extra_arguments] << args
  end

  opts.on("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

Dir.chdir options[:path] if options.has_key? :path
features = options[:features] || Dir.glob("**/*.feature")
extra_arguments = options[:extra_arguments].join(" ")

processes = features.map do |f|
  puts "Running #{f}"
  IO.popen("cucumber #{f} #{extra_arguments}")
end

begin
  results = Array.new(processes.length)
  collectors = processes.map {|p| Thread.start {results[processes.index(p)] = p.readlines}}
  collectors.each {|c| c.join}
  results.each { |r| puts "", r }
rescue SystemExit, Interrupt
  processes.each{|p| p.close}
  raise
end


