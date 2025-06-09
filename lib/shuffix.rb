require "shuffix/version"
require "shuffix/randomizer"

module Shuffix
  class Error < StandardError; end

  def self.shuffle(array)
    Randomizer.shuffle(array)
  end

  def self.enable!
    Randomizer.enable!
  end

  def self.disable!
    Randomizer.disable!
  end

  def self.enabled?
    Randomizer.enabled?
  end

  def self.with_seed(seed, &block)
    Randomizer.with_seed(seed, &block)
  end
end