module Autoini
  class Section < Element
    include InlineComment

    attr_accessor :title
    attr_reader   :lines

    def initialize(title, *contents)
      @title = title
      @lines = []
      self << contents
    end

    def self.[](title, hash)
      raise ArgumentError, "must pass a hash" unless hash.is_a?(Hash)
      new title, *hash.map{ |k, v| Pair.new(k, v) }
    end

    def <<(contents)
      Autoini.wrap(contents).each do |c|
        unless c.is_a?(AbstractLine)
          raise ArgumentError, "#{c.class.name} must extend Autoini::AbstractLine"
        end
        @lines << c
      end
    end

    def to_s
      [line_comment("[#{title}]"), lines.map(&:to_s)].flatten.join(Autoini.newline)
    end

    def to_a
      [title, lines.map(&:to_a).reject(&:empty?).to_h]
    end

    def ==(e)
      e.is_a?(Section) && e.title == title && e.comment == comment &&
        e.lines.length == lines.length &&
        lines.map.with_index{ |l, i| e.lines[i] == l }.all?
    end

    def pair(key)
      lines.select{ |l| l.is_a?(Pair) && l.key.to_s == key.to_s }.first
    end

    def merge!(other_section)
      unless other_section.is_a?(Section)
        raise ArgumentError, "must pass a Autoini::Section"
      end
      other_section.lines.each do |l|
        next unless l.is_a?(Pair)
        if p = pair(l.key)
          p.value = l.value
        else
          self << l
        end
      end
      self
    end

    def self.parse(line)
      Section.new(line[1]) if line.length == 3 && line[0] == '[' && line[2] == ']'
    end
  end
end
