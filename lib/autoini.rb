require "autoini/element"
require "autoini/abstract_line"
require "autoini/comment"
require "autoini/inline_comment"
require "autoini/pair"
require "autoini/section"
require "autoini/blank_line"
require "autoini/contents"
require "autoini/version"

module Autoini
  ESCAPE_CHAR = '\\'
  COMMENTS    = %w( # ; )
  SPECIAL     = %w( = [ ] ) | [ESCAPE_CHAR] | COMMENTS
  MAP_CHARS   = { "\r" => '\\r', "\n" => '\\n' }

  @newline = "\n"
  @comment = '#'

  class << self
    attr_accessor :newline, :comment

    def read(file)
      Contents.hash(File.open(file, 'rb', &:read))
    end

    def write(file, data)
      File.write(file, Contents[data].to_s)
    end

    def merge(file, data)
      Contents.parse((File.open(file, 'rb', &:read) rescue nil))
        .merge!(Contents[data]).tap{ |c| File.write(file, c.to_s) }.to_h
    end

    def escape(text)
      ''.tap do |b|
        text.to_s.each_char do |c|
          b << MAP_CHARS[c] and next if MAP_CHARS[c]
          b << '\\' if SPECIAL.include?(c)
          b << c
        end
      end
    end

    def unescape_char(char)
      return char if SPECIAL.include?(char)
      MAP_CHARS.key("\\#{char}") ||
        raise(ArgumentError, "#{char.inspect} is not an unescapable character")
    end

    def divide(text)
      [].tap do |s|
        buffer = ''
        escaping = false
        text.each_char do |c|
          if escaping
            buffer << unescape_char(c)
            escaping = false
          elsif c == ESCAPE_CHAR
            escaping = true
          elsif SPECIAL.include?(c)
            s << buffer.strip unless buffer.strip.empty?
            s << c
            buffer = ''
          else
            buffer << c
          end
        end
        s << buffer.strip unless buffer.strip.empty?
      end
    end

    def wrap(array)
      case array
      when nil
        []
      when Array
        array
      else
        [array]
      end
    end
  end
end