require 'test_helper'

class AutoiniTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Autoini::VERSION
  end

  def test_array_wrap
    assert_equal [], Autoini.wrap(nil)
    assert_equal [1, 2, 3], Autoini.wrap([1, 2, 3])
    assert_equal ['hello'], Autoini.wrap('hello')
  end

  def test_output
    ini = Autoini::Contents.new(
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
    )

    assert_equal ini, Autoini::Contents.parse(ini.to_s)
  end

  def test_blank_line
    assert Autoini::BlankLine.new == Autoini::BlankLine.new
  end

  def test_escape
    assert_equal 'hello \\= hi', Autoini.escape('hello = hi')
  end

  def test_pair
    assert_equal 'hello=hi', Autoini::Pair.new('hello', 'hi').to_s

    pair = Autoini::Pair.parse_with_comment(['foo', '=', 'bar'])
    assert pair.is_a?(Autoini::Pair)
    assert_equal 'foo', pair.key
    assert_equal 'bar', pair.value
    refute Autoini::Pair.parse_with_comment(['foo=bar']).is_a?(Autoini::Pair)

    pair = Autoini::Pair.parse_with_comment(['foo', '=', 'bar', '#', 'comment'])
    assert pair.is_a?(Autoini::Pair)
    assert_equal 'foo', pair.key
    assert_equal 'bar', pair.value
    assert_equal 'comment', pair.comment
  end

  def test_comment
    assert_equal "#{Autoini.comment} hello world",
      Autoini::Comment.new('hello world').to_s

    assert Autoini::Comment.parse(['#', ' hello world']).is_a?(Autoini::Comment)
    refute Autoini::Comment.parse(['# hello world']).is_a?(Autoini::Comment)
  end

  def test_section
    section = Autoini::Section.new('foo bar')
    assert_equal "[foo bar]", section.to_s

    section << Autoini::Comment.new('example')
    section << Autoini::Pair.new('hello', "world\n")
    assert_equal "[foo bar]\n\# example\nhello=world\\n", section.to_s
  end

  def test_divide
    assert_equal ['hello', '=', "world\r\nnewline"], Autoini.divide("hello=world\r\nnewline")
  end
end
