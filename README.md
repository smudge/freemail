# Freemail

A ruby implementation of the npm [freemail](https://github.com/willwhite/freemail) module, which
provides a database of free and [disposable](http://en.wikipedia.org/wiki/Disposable_email_address)
email domains.

All credit for `free.txt` and `disposable.txt` go to the npm
[freemail](https://github.com/willwhite/freemail) maintainers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'freemail', require: false
```

And then execute:

    $ bundle

## Usage

```ruby
require 'freemail'

Freemail.free?('howard@gmail.com')
# true
Freemail.free?('george@mailinater.com')
# true
Freemail.disposable?('howard@gmail.com')
# false
Freemail.disposable?('george@mailinater.com')
# true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`, or specify a path option in your gemfile:

```ruby
gem 'freemail', path: '../path/to/your/copy'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/smudge/freemail.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
