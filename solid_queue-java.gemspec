# frozen_string_literal: true

require_relative "lib/solid_queue/java/version"

Gem::Specification.new do |spec|
  spec.name = "solid_queue-java"
  spec.version = SolidQueue::Java::VERSION
  spec.authors = ["Abdelkader Boudih"]
  spec.email = ["terminale@gmail.com"]

  spec.summary = "Java/JRuby support for Solid Queue"
  spec.description = "Enables Solid Queue on JRuby and TruffleRuby by replacing fork-based workers with Java ExecutorService"
  spec.homepage = "https://github.com/seuros/solid_queue-java"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.glob(%w[lib/**/*.rb README.md LICENSE.txt])
  spec.require_paths = ["lib"]

  spec.add_dependency "solid_queue", ">= 1.2.0"
end
