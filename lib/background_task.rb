class BackgroundTask
  attr_accessor :name
  attr_reader :output,:status

  def initialize(command)
    @status = :pending
    @runner_thread = Thread.start do
      @output = IO.popen(command) { |out| out.readlines }
      process_status = $?
      @status = process_status.success? ? :success : :failure
      @output.each{|l| l.strip!}
    end
  end

  def self.start(command,name=nil)
    task = BackgroundTask.new(command)
    task.name=name
    task
  end

  def wait_for_exit
    @runner_thread.join
  end

  def close
    @runner_thread.kill
    @status = :aborted if @status == :pending
  end
end