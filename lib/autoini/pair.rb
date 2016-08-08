module Autoini
  class Pair < AbstractLine
    include InlineComment

    attr_accessor :key, :value

    def initialize(key, value)
      @key = key
      @value = value
    end

    def to_s
      line_comment("#{Autoini.escape(key)}=#{Autoini.escape(value)}")
    end

    def ==(e)
      e.is_a?(Pair) && e.key == key && e.value == value && e.comment == comment
    end

    def self.parse(line)
      Pair.new(line[0], line[2]) if line.length == 3 && line[1] == '='
    end
  end
end