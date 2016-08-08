module Autoini
  module InlineComment
    def self.included(base)
      base.extend(ClassMethods)
    end

    attr_accessor :comment

    def line_comment(text)
      return text unless comment
      "#{text} #{Comment.new(comment).to_s}"
    end

    module ClassMethods
      def parse_with_comment(line)
        comment_index = COMMENTS.map{ |c| line.index(c) }.reject(&:nil?).min
        return parse(line) unless comment_index
        parse(line[0..(comment_index - 1)]).tap do |e|
          e.comment = line[(comment_index + 1)..-1].join if e
        end
      end
    end
  end
end
