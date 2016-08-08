# Autoini

Autoini is a library for writing and parsing INI files. It supports key/value pairs, sections, blank lines and comments

It will escape control characters ([]=;#\r\n), so any data can be stored

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'autoini'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install autoini

## Usage

To parse INI data:
```ruby
ini = Autoini::Contents.parse(File.open('data.ini', 'rb', &:read))
```

To generate INI data:
```ruby
Autoini::Contents.new(
  Autoini::Comment.new('some comment'),
  Autoini::Pair.new('foo', "bar\nnew"),
  Autoini::Pair.new('foo2', 'bar').tap{ |p| p.comment = 'a comment' },
  Autoini::Section.new(
    'hello',
    Autoini::Pair.new('[foo', 'bar'),
    Autoini::Pair.new('fo;o2', 'bar').tap{ |p| p.comment = 'a comment' },
    Autoini::BlankLine.new
  ),
  Autoini::Section.new(
    'world',
    Autoini::Pair.new('foo', 'bar'),
    Autoini::Pair.new('foo2', 'bar').tap{ |p| p.comment = 'a comment' },
  ).tap{ |p| p.comment = 'cool section' },
).to_s
```
which will output:
```
# some comment
foo=bar\nnew
foo2=bar # a comment
[hello]
\[foo=bar
fo\;o2=bar # a comment

[world] # cool section
foo=bar
foo2=bar # a comment
```

## Config

Autoini will always parse lines in a string by \n, but you can choose the new line string using:
```ruby
Autoini.newline = "\r\n"
```

Autoini will parse comments as begining with a ; or a #. You can choose which it uses to write comments by using:
```ruby
Autoini.comment = ";"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/automeow/autoini. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

