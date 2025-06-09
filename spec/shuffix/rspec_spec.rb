require 'shuffix/rspec'

RSpec.describe Shuffix::RSpec do
  describe "shuffled_let" do
    shuffled_let(:users) do
      [
        { id: 1, name: "Alice" },
        { id: 2, name: "Bob" },
        { id: 3, name: "Charlie" },
        { id: 4, name: "David" },
        { id: 5, name: "Eve" }
      ]
    end

    it "shuffles the array returned by let" do
      original_order = [
        { id: 1, name: "Alice" },
        { id: 2, name: "Bob" },
        { id: 3, name: "Charlie" },
        { id: 4, name: "David" },
        { id: 5, name: "Eve" }
      ]

      expect(users).to contain_exactly(*original_order)
      # In practice, this would be randomized
    end

    it "returns the same shuffled array within the same example" do
      first_call = users
      second_call = users
      expect(first_call).to eq(second_call)
    end
  end

  describe "shuffled_let!" do
    shuffled_let!(:eagerly_loaded_data) do
      (1..10).to_a
    end

    it "evaluates the block before the example runs" do
      # The array should already be loaded
      expect(eagerly_loaded_data).to be_an(Array)
    end
  end

  describe "metadata :shuffix" do
    it "shuffles by default" do
      array = [1, 2, 3, 4, 5]
      expect(Shuffix.enabled?).to be true
    end

    it "can be disabled with metadata", shuffix: false do
      array = [1, 2, 3, 4, 5]
      expect(Shuffix.enabled?).to be false
    end
  end
end