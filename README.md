# Shuffix

[![CI](https://github.com/pranc1ngpegasus/shuffix/actions/workflows/ci.yml/badge.svg)](https://github.com/pranc1ngpegasus/shuffix/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/shuffix.svg)](https://badge.fury.io/rb/shuffix)

Shuffix is a Ruby gem that randomizes test fixtures for RSpec and Minitest, ensuring your application logic handles unordered data correctly. It's particularly useful for applications using NewSQL databases where ORDER BY may be unreliable due to sharding.

## Background

In NewSQL databases, ORDER BY may not work as expected due to sharding. This requires sorting at the application layer, but it's crucial to test that this implementation is correct.

Shuffix helps by randomizing test data order, allowing you to verify that your code works correctly regardless of input order.

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'shuffix'
end
```

And then execute:

```bash
$ bundle install
```

## Usage

### With RSpec

Add the following to your spec_helper.rb or rails_helper.rb:

```ruby
require 'shuffix/rspec'
```

This will automatically configure Shuffix for your tests.

#### shuffled_let helper

```ruby
RSpec.describe UserService do
  # Regular let - preserves order
  let(:users) do
    [
      { id: 1, name: "Alice" },
      { id: 2, name: "Bob" },
      { id: 3, name: "Charlie" }
    ]
  end

  # shuffled_let - randomizes order each time
  shuffled_let(:random_users) do
    [
      { id: 1, name: "Alice" },
      { id: 2, name: "Bob" },
      { id: 3, name: "Charlie" }
    ]
  end

  it "sorts users by name regardless of input order" do
    sorted = UserService.sort_by_name(random_users)
    expect(sorted.map { |u| u[:name] }).to eq(["Alice", "Bob", "Charlie"])
  end
end
```

#### Disabling Shuffix for specific tests

```ruby
it "preserves original order", shuffix: false do
  # Shuffling is disabled for this test
  array = [1, 2, 3]
  expect(Shuffix.shuffle(array)).to eq([1, 2, 3])
end
```

### With Minitest

Add the following to your test_helper.rb:

```ruby
require "minitest/autorun"
require "shuffix"
require "shuffix/minitest"
```

**Important:** Make sure to require `minitest/autorun` first, then `shuffix`, and finally `shuffix/minitest` to ensure proper integration.

#### shuffled_fixture helper

```ruby
class UserServiceTest < Minitest::Test
  def test_sorts_users_by_name
    users = shuffled_fixture([
      { id: 1, name: "Alice" },
      { id: 2, name: "Bob" },
      { id: 3, name: "Charlie" }
    ])

    sorted = UserService.sort_by_name(users)
    assert_equal ["Alice", "Bob", "Charlie"], sorted.map { |u| u[:name] }
  end

  def test_with_disabled_shuffix
    with_shuffix_disabled do
      array = [1, 2, 3]
      assert_equal [1, 2, 3], Shuffix.shuffle(array)
    end
  end
end
```

#### Environment variables

```bash
# Disable Shuffix
$ DISABLE_SHUFFIX=true bundle exec rake test

# Specify seed for reproducible randomization
$ SHUFFIX_SEED=12345 bundle exec rake test
```

### Direct usage

```ruby
require 'shuffix'

# Shuffle an array
shuffled = Shuffix.shuffle([1, 2, 3, 4, 5])

# Disable shuffling
Shuffix.disable!
Shuffix.shuffle([1, 2, 3]) # => [1, 2, 3]

# Enable shuffling
Shuffix.enable!

# Use with specific seed
Shuffix.with_seed(42) do
  result1 = Shuffix.shuffle((1..100).to_a)
  result2 = Shuffix.shuffle((1..100).to_a)
  # result1 == result2 (same results with same seed)
end
```

## Configuration

### Environment variables

Shuffix can be controlled using environment variables:

- `DISABLE_SHUFFIX=true` or `NO_SHUFFIX=true` - Disable shuffling globally
- `SHUFFIX_SEED=12345` - Set a fixed seed for reproducible randomization

### Programmatic configuration

```ruby
# Disable/enable shuffling
Shuffix.disable!
Shuffix.enable!

# Check if enabled
Shuffix.enabled?

# Use with specific seed
Shuffix.with_seed(42) do
  # All shuffling within this block uses the same seed
end
```

## Best Practices

1. **Use in CI**: Enable Shuffix in your CI environment to catch order-dependent bugs early
2. **Record seeds**: When tests fail, record the seed value for reproducibility
3. **Gradual adoption**: Introduce Shuffix gradually to existing test suites to identify issues

## Development

After checking out the repo:

```bash
$ nix develop  # Using Nix environment
$ bundle install
$ bundle exec rspec
$ bundle exec rake test
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).