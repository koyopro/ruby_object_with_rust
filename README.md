Example of using Rust struct as Ruby class
==

## Requirements

- Ruby 2.6.6
- Rust 1.48.0

## Build

```rust
cargo build --release
```

## Setup Gems

```
bundle install
```

## Test

```rust
cargo test
```

```ruby
bundle exec rspec
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
