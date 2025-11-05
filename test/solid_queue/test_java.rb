# frozen_string_literal: true

require "test_helper"

class SolidQueue::TestJava < ActiveSupport::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::SolidQueue::Java::VERSION
  end

  def test_solid_queue_is_loaded
    assert defined?(SolidQueue)
  end

  def test_solid_queue_version
    refute_nil SolidQueue::VERSION
  end

  def test_java_executor_available
    assert defined?(SolidQueue::Java::Executor)
  end

  def test_supervisor_patched_with_java_executor
    supervisor_methods = ::SolidQueue::Supervisor.instance_methods
    assert supervisor_methods.include?(:spawn_workers), "Supervisor should have spawn_workers method"
  end

  def test_supervisor_patch_module_included
    # Check that SupervisorPatch was prepended to Supervisor
    assert ::SolidQueue::Supervisor.ancestors.include?(SolidQueue::Java::SupervisorPatch),
           "SolidQueue::Java::SupervisorPatch should be in Supervisor ancestors"
  end
end
