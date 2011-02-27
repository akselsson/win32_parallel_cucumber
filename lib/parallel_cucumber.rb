require 'background_task'
class ParallelCucumber
  def self.run(options)
    Dir.chdir options[:path] if options.has_key? :path
    features = options[:features] || Dir.glob("**/*.feature")
    extra_arguments = options[:extra_arguments] || ""

    begin
      features.each {|f| puts "Running #{f}" }
      processes = features.map { |f| BackgroundTask.start("cucumber #{f} #{extra_arguments}") }
      processes.each{|p| p.wait_for_exit}
      {:lines => processes.map{|p| p.output}.flatten,
      :passed? => processes.all?{|p| p.status == :success}}
    rescue SystemExit, Interrupt
      processes.each { |p| p.close }
      raise
    end
  end
end



