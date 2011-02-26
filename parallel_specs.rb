require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on("-p v", "--path v", "Feature path") do |v|
    options[:path] = v
  end

  opts.on("--features x,y,z",Array,"Features") do |f|
    options[:features] = f
  end

  opts.on("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

Dir.chdir options[:path] if options.has_key? :path
features = options[:features] || Dir.glob("**/*.feature")

procs = features.map do |f|
  puts "Starting #{f}"
  IO.popen("cucumber " + f)
end

results = Array.new(procs.length)
collectors = procs.map {|r| Thread.start {results[procs.index(r)] = r.readlines}}
collectors.each{|c| c.run}.each {|c| c.join}

results.each { |r| puts "", r }

