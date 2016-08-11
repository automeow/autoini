module Autoini
  class Contents
    KLASSES = [Pair, Section, Comment, BlankLine]

    attr_reader :lines

    def self.parse(contents)
      return new if contents.nil? || contents.empty?
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

    def self.hash(contents)
      parse(contents).to_h
    end

    def self.[](hash)
      raise ArgumentError, "must pass a hash" unless hash.is_a?(Hash)
      new(
        *hash.map do |k, v|
          if v.is_a?(Hash)
            Section[k, v]
          else
            Pair.new(k, v)
          end
        end
      )
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
          raise ArgumentError, "Error on line #{c.inspect}: all elements " \
            "after a section must be in a section"
        end
        lines << c
      end
    end

    def section(key)
      lines.select{ |l| l.is_a?(Section) && l.title.to_s == key.to_s }.first
    end

    def pair(key)
      lines.select{ |l| l.is_a?(Pair) && l.key.to_s == key.to_s }.first
    end

    def merge!(other_contents)
      unless other_contents.is_a?(Contents)
        raise ArgumentError, "must pass a Autoini::Contents"
      end
      other_contents.lines.each do |l|
        case l
        when Section
          if s = section(l.title)
            s.merge!(l)
          else
            self << l
          end
        when Pair
          if p = pair(l.key)
            p.value = l.value
          else
            self << l
          end
        end
      end
      self
    end

    def to_s
      lines.map(&:to_s).join(Autoini.newline)
    end

    def to_h
      lines.map(&:to_a).reject(&:empty?).to_h
    end

    def ==(c)
      c.is_a?(Contents) && c.lines.length == lines.length &&
        lines.map.with_index{ |l, i| c.lines[i] == l }.all?
    end
  end
end
