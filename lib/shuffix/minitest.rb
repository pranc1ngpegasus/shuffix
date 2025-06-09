require 'shuffix/randomizer'

module Shuffix
  module Minitest
    module FixtureShuffler
      def shuffled_fixture(array)
        return array unless array.is_a?(Array)
        Shuffix::Randomizer.shuffle(array)
      end

      def with_shuffix_disabled(&block)
        Shuffix::Randomizer.disable!
        yield
      ensure
        Shuffix::Randomizer.enable!
      end

      def with_shuffix_seed(seed, &block)
        Shuffix::Randomizer.with_seed(seed, &block)
      end
    end

    module Plugin
      def self.included(base)
        base.class_eval do
          include Shuffix::Minitest::FixtureShuffler
        end
      end
    end
  end
end

# Extension for Minitest::Test
if defined?(::Minitest::Test)
  ::Minitest::Test.include(Shuffix::Minitest::FixtureShuffler)
end

# Plugin registration for Minitest
if defined?(::Minitest)
  module Minitest
    def self.plugin_shuffix_init(options)
      # Enable Shuffix unless disabled by environment variable
      unless ENV['DISABLE_SHUFFIX'] || ENV['NO_SHUFFIX']
        Shuffix::Randomizer.enable!
      end
    end
  end
end