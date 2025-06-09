module Shuffix
  class Randomizer
    class << self
      def shuffle(array)
        return array unless enabled?
        return array if array.nil? || array.empty?

        array.dup.tap do |arr|
          arr.shuffle!(random: random_generator)
        end
      end

      def enabled?
        return @enabled if defined?(@enabled)
        # Check environment variable
        if ENV['DISABLE_SHUFFIX'] || ENV['NO_SHUFFIX']
          @enabled = false
        else
          @enabled = true
        end
      end

      def enable!
        @enabled = true
      end

      def disable!
        @enabled = false
      end

      def with_seed(seed)
        original_generator = defined?(@random_generator) ? @random_generator : nil
        @random_generator = Random.new(seed)
        yield
      ensure
        @random_generator = original_generator
      end

      private

      def random_generator
        @random_generator ||= begin
          if ENV['SHUFFIX_SEED']
            Random.new(ENV['SHUFFIX_SEED'].to_i)
          else
            Random.new
          end
        end
      end
    end
  end
end