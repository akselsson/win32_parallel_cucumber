class BackgroundTask
  def initialize(command)
    @runner_thread = Thread.start do
      @lines = IO.popen(command) { |out| out.readlines }
      process_status = $?
      @status = process_status.exitstatus == 0 ? :success : :failure
      @lines.each{|l| l.strip!}
    end
  end

  def self.start(arg)
    BackgroundTask.new(arg)
  end

  def wait_for_exit
    @runner_thread.join
  end

  def output
    @lines
  end

  def status
    @status
  end
end