module Autoini
  class AbstractLine < Element
    def to_s
      raise ArgumentError, "to_s must be overriden in the subclass"
    end

    def self.parse(line)
      raise ArgumentError, "parse must be overriden in the subclass"
    end
  end
end
