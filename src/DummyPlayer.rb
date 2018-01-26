class DummyPlayer

  def initialize
    @total = 0
  end

  def name
    return "DummyPlayer"
  end

  def choose(awale,previous,lost)
    for i in 0..5
      if(awale[0][i] != 0)
	return i
      end
    end
  end

  def earn(score)
    @total += score
  end
end
