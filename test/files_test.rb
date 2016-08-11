require 'test_helper'

class FilesTest < Minitest::Test
  FIXTURES_PATH = 'test/fixtures/'
  FILE_PATH = FIXTURES_PATH + 'data.ini'

  def setup
    Dir.mkdir(FIXTURES_PATH) unless File.exists?(FIXTURES_PATH)
    Autoini.write(FILE_PATH, foo: 'bar')
  end

  def test_read
    assert_equal({ foo: 'bar' }, Autoini.read(FILE_PATH))
  end

  def test_overwrite
    Autoini.write(FILE_PATH, foo: { bar: 'hello world' })
    assert_equal({ foo: { bar: 'hello world' } },
      Autoini.read(FILE_PATH))
  end

  def test_merge
    assert_equal({ foo: 'bar', hello: 'world' },
      Autoini.merge(FILE_PATH, hello: 'world'))
    assert_equal({ foo: 'bar', hello: 'world' },
      Autoini.read(FILE_PATH))
  end

  def test_merge_section
    assert_equal({ foo: 'bar', section: { foo: 'bar' } },
      Autoini.merge(FILE_PATH, section: { foo: 'bar' }))
    assert_equal({ foo: 'bar', section: { foo: 5 } },
      Autoini.merge(FILE_PATH, section: { foo: 5 }))
    assert_equal({ foo: 'bar', section: { foo: '5', bar: 6 } },
      Autoini.merge(FILE_PATH, section: { bar: 6 }))
  end
end
