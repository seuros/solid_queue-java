# frozen_string_literal: true

module SolidQueue
  module Java
    # Worker pool implementation - uses Java ExecutorService on JRuby, Threads on TruffleRuby
    class Executor
      if RUBY_ENGINE == 'jruby'
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
      else
        # TruffleRuby: use native threads
        attr_reader :worker_count, :threads

        def executor_service
          self
        end

        def initialize(worker_count = 4)
          @worker_count = worker_count
          @threads = []
          @queue = ::Queue.new
          @shutdown = false

          worker_count.times do
            @threads << Thread.new { run_worker }
          end
        end

        def submit(&block)
          @queue.push(block)
        end

        def shutdown
          shutdown_now
          @threads.each(&:join)
        end

        def shutdown_now
          @shutdown = true
          @queue.close
        end

        def wait_for_all
          @threads.each(&:join)
        end

        private

        def run_worker
          while (work = @queue.pop)
            work.call
          end
        rescue ClosedQueueError
          # Queue closed, thread exits
        end
      end
    end
  end
end
