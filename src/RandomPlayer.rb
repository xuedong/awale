class RandomPlayer

  def initialize
    @total = 0
  end
    
    def name
        return "RandMan"
    end

	def choose(awale,previous,lost)
		options = []
		for i in 0..5
			if(awale[0][i] != 0)
				options << i
			end
		end
		x = (rand*options.size).to_i
		return options[x]
	end

	def earn(score)
		@total += score
	end
end
