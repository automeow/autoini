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

### Reading / writing to files

If you just want to read/write data to files, these 3 methods are all you need:

To read an INI file into a hash object:
```ruby
hash = Autoini.read('data.ini')
```

To write INI data to a file:
```ruby
Autoini.write('data.ini', section: { foo: :bar })
```

To merge INI data into a file:
```ruby
Autoini.merge('data.ini', section: { another: :value })
```

### Advanced manipulation

If you need to read/write comments and blank lines, or alter INI data without writing to a file, you can use the following classes

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

Autoini will always parse lines in a string/file by \n, but you can choose how Autoini writes a new line using:
```ruby
Autoini.newline = "\r\n"
```

Autoini will parse comments as begining with a ; or a #. You can choose which it uses to write comments by using:
```ruby
Autoini.comment = ";"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/automeow/autoini.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

