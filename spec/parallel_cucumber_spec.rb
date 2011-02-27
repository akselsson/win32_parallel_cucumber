require 'rspec'
require 'time'
require 'benchmark'
require 'spec_helper'

describe 'parallel_cucumber' do
  def run(opts)
    @results = ParallelCucumber.run(opts)
  end
  it 'should report output from one feature' do
    run({:features => ["features/fast.feature"]})
    @results[:lines].should include("Feature: Fast feature")
  end
  it 'should report output from two features' do
    run({:features => ["features/fast.feature","features/fast2.feature"]})
    @results[:lines].should include("Feature: Fast feature")
    @results[:lines].should include("Feature: Fast feature 2")
  end
  it 'should take shorter time than running features sequentially' do
    time_taken = Benchmark.measure { run({:path => "."}) }
    time_taken.real.should < 30
  end
  it 'should forward success from features' do
    run({:features => ["features/fast.feature"]})
    @results[:passed?].should be_true
  end
  it 'should forward failure from features' do
    run({:features => ["features/fail.feature"]})
    @results[:passed?].should be_false
  end
end