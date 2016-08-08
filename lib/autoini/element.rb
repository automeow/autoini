module Autoini
  class Element
    def ==(element)
      raise ArgumentError, "== must be overriden in the subclass"
    end
  end
end
