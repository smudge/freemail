# Freemail [![Build Status](https://img.shields.io/travis/smudge/freemail.svg)](https://travis-ci.org/smudge/freemail) [![Maintainability](https://api.codeclimate.com/v1/badges/8801015d3bfce638ab08/maintainability)](https://codeclimate.com/github/smudge/freemail/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/8801015d3bfce638ab08/test_coverage)](https://codeclimate.com/github/smudge/freemail/test_coverage)

A ruby implementation of the npm [freemail](https://github.com/willwhite/freemail) module, which
provides a database of free and [disposable](http://en.wikipedia.org/wiki/Disposable_email_address)
email domains.

All credit for `free.txt` and `disposable.txt` goes to the npm
[freemail](https://github.com/willwhite/freemail) maintainers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'freemail', require: false
```

And then execute:

    $ bundle

## Usage

### Basic usage

```ruby
require 'freemail'

Freemail.free?('howard@gmail.com')
# true
Freemail.free?('george@mailinater.com')
# false
Freemail.disposable?('howard@gmail.com')
# false
Freemail.disposable?('george@mailinater.com')
# true
```

### API for custom domains

```ruby
require 'freemail'

email = 'example@superlocalfreeemail.com'

Freemail.free?(email)
# false

Freemail.add_free_domains('superlocalfreeemail.com')
# or by Array
Freemail.add_free_domains(['superlocalfreeemail.com'])

Freemail.free?(email)
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
