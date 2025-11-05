# frozen_string_literal: true

module SolidQueue
  module Java
    # Java ExecutorService-based worker pool implementation
    class Executor
      java_import java.util.concurrent.Executors
      java_import java.util.concurrent.TimeUnit

      attr_reader :executor_service, :worker_count

      def initialize(worker_count = 4)
        @worker_count = worker_count
        @executor_service = Executors.newFixedThreadPool(worker_count)
        @futures = []
      end

      def submit(&block)
        future = @executor_service.submit(block)
        @futures << future
        future
      end

      def shutdown
        @executor_service.shutdown
        @executor_service.awaitTermination(30, TimeUnit::SECONDS)
      end

      def shutdown_now
        @executor_service.shutdownNow
      end

      def wait_for_all
        @executor_service.awaitTermination(Integer::MAX_VALUE, TimeUnit::SECONDS)
      end
    end
  end
end
