require "test_helper"

class ShuffixMinitestTest < Minitest::Test
  def test_shuffled_fixture
    users = [
      { id: 1, name: "Alice" },
      { id: 2, name: "Bob" },
      { id: 3, name: "Charlie" },
      { id: 4, name: "David" },
      { id: 5, name: "Eve" }
    ]

    shuffled_users = shuffled_fixture(users)

    assert_equal users.length, shuffled_users.length
    users.each do |user|
      assert_includes shuffled_users, user
    end
  end

  def test_with_shuffix_disabled
    array = [1, 2, 3, 4, 5]

    with_shuffix_disabled do
      result = Shuffix.shuffle(array)
      assert_equal array, result
    end

    # Should be enabled again
    assert Shuffix.enabled?
  end

  def test_with_shuffix_seed
    array = (1..100).to_a

    result1 = with_shuffix_seed(42) do
      Shuffix.shuffle(array)
    end

    result2 = with_shuffix_seed(42) do
      Shuffix.shuffle(array)
    end

    assert_equal result1, result2
  end

  def test_non_array_returns_unchanged
    assert_equal "string", shuffled_fixture("string")
    assert_equal 123, shuffled_fixture(123)
    assert_nil shuffled_fixture(nil)
  end
end