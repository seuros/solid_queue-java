# frozen_string_literal: true

require "solid_queue"
require_relative "java/version"
require_relative "java/executor"
require_relative "java/patches"

module SolidQueue
  module Java
    class Error < StandardError; end

    # Java/JRuby implementation of SolidQueue
    # Uses Java ExecutorService instead of fork() for thread-based workers

    # Auto-apply patches on load
    Patcher.apply!
  end
end
