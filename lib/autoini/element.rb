module Autoini
  class Element
    def ==(element)
      raise ArgumentError, "== must be overriden in the subclass"
    end

    def to_a(element)
      raise ArgumentError, "to_a must be overriden in the subclass"
    end
  end
end
