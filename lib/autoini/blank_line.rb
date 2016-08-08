module Autoini
  class BlankLine < AbstractLine
    def to_s
      ""
    end

    def ==(e)
      e.is_a?(BlankLine)
    end

    def self.parse_with_comment(line)
      parse(line)
    end

    def self.parse(line)
      BlankLine.new if line.empty?
    end
  end
end
