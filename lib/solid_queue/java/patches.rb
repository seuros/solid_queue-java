# frozen_string_literal: true

module SolidQueue
  module Java
    module SupervisorPatch
      def spawn_workers
        @executor_service = Executor.new(config.workers)
        @worker_threads = []

        config.workers.times do
          future = @executor_service.submit do
            worker = ::SolidQueue::Worker.new
            worker.run
          end
          @worker_threads << future
        end
      end

      def shutdown
        @executor_service.shutdown_now
      end
    end

    module Patcher
      def self.apply!
        ::SolidQueue::Supervisor.prepend(SupervisorPatch)
      end
    end
  end
end
