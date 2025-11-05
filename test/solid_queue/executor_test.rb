# frozen_string_literal: true

require "test_helper"

class SolidQueue::ExecutorTest < ActiveSupport::TestCase
  def test_executor_initialization
    executor = SolidQueue::Java::Executor.new(4)
    assert_equal 4, executor.worker_count
    refute_nil executor.executor_service
    executor.shutdown_now
  end

  def test_executor_submit_executes_block
    executor = SolidQueue::Java::Executor.new(2)
    result = []

    future = executor.submit do
      result << "executed"
    end

    wait_for(timeout: 2) { !result.empty? }
    assert_equal ["executed"], result

    executor.shutdown
  end

  def test_executor_multiple_submissions
    executor = SolidQueue::Java::Executor.new(2)
    results = []

    3.times do |i|
      executor.submit do
        results << i
        sleep 0.1
      end
    end

    wait_for(timeout: 2) { results.length == 3 }
    assert_equal 3, results.length
    assert_equal [0, 1, 2].sort, results.sort

    executor.shutdown
  end

  def test_supervisor_uses_executor
    assert ::SolidQueue::Supervisor.ancestors.include?(SolidQueue::Java::SupervisorPatch),
           "Supervisor should have been patched with ExecutorService support"
  end

  def test_supervisor_spawn_workers_method_exists
    assert ::SolidQueue::Supervisor.instance_methods.include?(:spawn_workers)
  end
end
