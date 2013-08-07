class AngleRange
  
  def initialize(from, to)
    @from = AngleRange::normalize(from)
    @to = AngleRange::normalize(to)    
  end
  
  def include?(angle)
    angle = AngleRange::normalize(angle)
    if (@from > @to)
      angle >= @from || angle <= @to
    else
      angle >= @from && angle <= @to
    end
  end
  
  def self.normalize(value)
    value < 0 ? value + 360 : value
    value %= 360
  end

end