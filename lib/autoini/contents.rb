module Autoini
  class Contents
    KLASSES = [Pair, Section, Comment, BlankLine]

    attr_reader :lines

    def self.parse(contents)
      elements = []
      section = nil
      contents.split("\n").each do |l|
        e = KLASSES.map{ |k| k.parse_with_comment(Autoini.divide(l.strip)) }
          .select(&:itself)
          .first || raise(ArgumentError, "couldn't parse line: #{l.inspect}")
        if e.is_a?(Section)
          section = e
          elements << section
        else
          (section || elements) << e
        end
      end
      new(*elements)
    end

    def initialize(*contents)
      @lines = []
      self << contents
    end

    def <<(contents)
      Autoini.wrap(contents).each do |c|
        unless c.is_a?(Element)
          raise ArgumentError, "#{c.class.name} must extend Autoini::Element"
        end
        if !c.is_a?(Section) && lines.last.is_a?(Section)
          raise ArgumentError, "Error on line #{c.inspect}: all elements after a section must be in a section"
        end
        lines << c
      end
    end

    def to_s
      lines.map(&:to_s).join(Autoini.newline)
    end

    def ==(c)
      c.is_a?(Contents) && c.lines.length == lines.length &&
        lines.map.with_index{ |l, i| c.lines[i] == l }.all?
    end
  end
end
