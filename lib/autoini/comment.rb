module Autoini
  class Comment < AbstractLine
    attr_accessor :comment

    def initialize(comment)
      @comment = comment
    end

    def to_s
      "#{Autoini.comment} #{@comment}"
    end

    def to_a
      []
    end

    def ==(e)
      e.is_a?(Comment) && comment == e.comment
    end

    def self.parse_with_comment(line)
      parse(line)
    end

    def self.parse(line)
      Comment.new(line[1..-1].join.strip) if line[0] == Autoini.comment
    end
  end
end
