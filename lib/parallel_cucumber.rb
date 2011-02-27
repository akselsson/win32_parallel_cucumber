class ParallelCucumber
  def self.run(options)
    Dir.chdir options[:path] if options.has_key? :path
    features = options[:features] || Dir.glob("**/*.feature")
    extra_arguments = options[:extra_arguments] || ""

    processes = features.map do |f|
      puts "Running #{f}"
      IO.popen("cucumber #{f} #{extra_arguments}")
    end

    begin
      results = Array.new(processes.length)
      collectors = processes.map { |p| Thread.start { results[processes.index(p)] = p.readlines } }
      collectors.each { |c| c.join }
      {:lines => results.flatten.map{|r| r.gsub("\n","")},
      :status => :success}
    rescue SystemExit, Interrupt
      processes.each { |p| p.close }
      raise
    end
  end
end



