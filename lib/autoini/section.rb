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

    def ==(e)
      e.is_a?(Section) && e.title == title && e.comment == comment &&
        e.lines.length == lines.length &&
        lines.map.with_index{ |l, i| e.lines[i] == l }.all?
    end

    def self.parse(line)
      Section.new(line[1]) if line.length == 3 && line[0] == '[' && line[2] == ']'
    end
  end
end
