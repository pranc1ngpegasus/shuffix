require 'shuffix/randomizer'

module Shuffix
  module RSpec
    module FixtureShuffler
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def shuffled_let(name, &block)
          let(name) do
            result = instance_eval(&block)
            if result.is_a?(Array)
              Shuffix::Randomizer.shuffle(result)
            else
              result
            end
          end
        end

        def shuffled_let!(name, &block)
          let!(name) do
            result = instance_eval(&block)
            if result.is_a?(Array)
              Shuffix::Randomizer.shuffle(result)
            else
              result
            end
          end
        end
      end
    end

    module Configuration
      def self.configure
        ::RSpec.configure do |config|
          config.include Shuffix::RSpec::FixtureShuffler

          config.before(:suite) do
            Shuffix::Randomizer.enable!
          end

          config.around(:each) do |example|
            if example.metadata[:shuffix] == false
              Shuffix::Randomizer.disable!
              example.run
              Shuffix::Randomizer.enable!
            else
              example.run
            end
          end

          config.after(:each) do
            Shuffix::Randomizer.enable! unless self.class.metadata[:shuffix] == false
          end
        end
      end
    end
  end
end

# Auto-configure when this file is required
if defined?(::RSpec)
  Shuffix::RSpec::Configuration.configure
end