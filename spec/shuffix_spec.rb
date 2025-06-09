RSpec.describe Shuffix do
  it "has a version number" do
    expect(Shuffix::VERSION).not_to be nil
  end

  describe ".shuffle" do
    let(:array) { [1, 2, 3, 4, 5] }

    it "returns a shuffled array" do
      shuffled = Shuffix.shuffle(array)
      expect(shuffled).to contain_exactly(*array)
      expect(shuffled).not_to eq(array)
    end

    it "does not modify the original array" do
      original = array.dup
      Shuffix.shuffle(array)
      expect(array).to eq(original)
    end

    it "returns nil when given nil" do
      expect(Shuffix.shuffle(nil)).to be_nil
    end

    it "returns empty array when given empty array" do
      expect(Shuffix.shuffle([])).to eq([])
    end
  end

  describe ".enable! and .disable!" do
    it "enables shuffling by default" do
      expect(Shuffix.enabled?).to be true
    end

    it "can disable shuffling" do
      Shuffix.disable!
      expect(Shuffix.enabled?).to be false

      array = [1, 2, 3, 4, 5]
      expect(Shuffix.shuffle(array)).to eq(array)

      Shuffix.enable!
    end
  end

  describe ".with_seed" do
    it "produces consistent results with the same seed" do
      array = (1..100).to_a

      result1 = Shuffix.with_seed(12345) do
        Shuffix.shuffle(array)
      end

      result2 = Shuffix.with_seed(12345) do
        Shuffix.shuffle(array)
      end

      expect(result1).to eq(result2)
    end
  end
end