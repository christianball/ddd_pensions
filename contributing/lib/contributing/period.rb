module Contributing
  class Period

    def initialize(starts_on:, ends_on:)
      @starts_on = Date.parse(starts_on)
      @ends_on = Date.parse(ends_on)
    end

    attr_reader :starts_on, :ends_on

    def <=>(other)
      (self.starts_on == other.starts_on) && (self.ends_on == other.ends_on)
    end

  end
end
