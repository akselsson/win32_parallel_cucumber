require "spec_helper"
require "background_task"

describe BackgroundTask do
  def run(command)
    @task = BackgroundTask.start(command)
    @task.wait_for_exit
  end

  after(:each) do
    @task.close if @task
  end

  it "should return one line from echo" do
    run "echo test"
    @task.output.should include("test")
  end
  it "should return two lines from ruby" do
    run %{ruby -e 'puts "a", "b"'}
    @task.output.should == ["a","b"]
  end

  it "should have success status when command succeeds" do
    run "echo test"
    @task.status.should == :success
  end

  it "should have failure status when command fails" do
    run %{ruby -e 'exit 1'}
    @task.status.should == :failure
  end

  it "should have no lines until command is finished" do
    @task = BackgroundTask.start(%(ruby -e 'sleep 1'))
    @task.output.should_not be
  end

  it "should be pemding unitl command is finished" do
    @task = BackgroundTask.start(%(ruby -e 'sleep 1'))
    @task.status.should == :pending
  end

  it "should be aborted if closed before command is finished" do
    @task = BackgroundTask.start(%(ruby -e 'sleep 1'))
    @task.close
    @task.status.should == :aborted
  end
end