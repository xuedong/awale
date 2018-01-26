#!/usr/bin/env ruby
$LOAD_PATH << "."
$LOAD_PATH << "policy/"

require "set"
require "benchmark"

class Competition

	def initialize(players,out=$stdout)
		@out = out
		@out << "="*80+"\n"
		@out << " "*20+"Welcome to the Awale Ruby competition!\n"
		@out << "="*80+"\n"
		players.uniq.each do | player |
			require player+".rb"
		end
		@players = players
	end

	def start
		x = 1
		for i in 0...@players.size
			for j in 0...i
				p1_class = @players[i]
				p2_class = @players[j]
				p1 = eval(p1_class+".new")
				p2 = eval(p2_class+".new")
				p1_name = p1.name
				p2_name = p2.name
				@out << "Match #{x}: #{p1_name} versus #{p2_name}\n"
				@out << "- First game\t:\t "
				results = match([p1,p2])
				scores = results[:score]
				times = results[:times]
				@out << "#{scores[0]} - #{scores[1]}\t times (usec) #{times[0]} - #{times[1]}\n"
				if(scores[0] == scores[1])
					@out << "\t\tdraw\n"
				elsif(scores[0] > scores[1])
					@out << "\t\t#{p1_name} wins\n"
				else
					@out << "\t\t#{p2_name} wins\n"
				end
				p1 = eval(p1_class+".new")
				p2 = eval(p2_class+".new")
				@out << "- Second game\t:\t "
				results = match([p2,p1])
				scores = results[:score]
				times = results[:times]
				@out << "#{scores[1]} - #{scores[0]}\t times (usec) #{times[1]} - #{times[0]}\n"
				if(scores[0] == scores[1]) 
					@out << "\t\tdraw\n"
				elsif(scores[0] < scores[1])
					@out << "\t\t#{p1_name} wins\n"
				else
					@out << "\t\t#{p2_name} wins\n"
				end
				@out << "-"*80+"\n"
			end
		end
	end

	private

	def match(players)
		awale = [[4,4,4,4,4,4],[4,4,4,4,4,4]]
		previous = -1
		lost = 0
		score = [0,0]
		times = [0,0]
		i = 0

		while(true)
			# select current player
			current = players[i%2]
			# current player chooses
			GC.start
			GC.disable

			awale2 = [[0,0,0,0,0,0],[0,0,0,0,0,0]]
			for j in 0...12
				awale2[j/6][j%6] = awale[j/6][j%6]
			end
			x = -1
			b = Benchmark.measure do
				x = current.choose(awale2,previous,lost)
			end
			GC.enable
			times[i%2] += (b.total*(10**12)).to_i

			# play
			if x >= 0 && x < 6 && awale[0][x] > 0
				gain = play(awale,x)
			else
				# the player cheated, or played an invalid position
				gain = -1
			end

			# the case of an infinite loop or the player cheated
			if gain == -1
				gain = 0
				awale[1].each do | t | gain += t end
				awale[0].each do | t | gain += t end
				score[(i+1)%2] += gain
				break
			end
			# after this we are sure the player didn't do an infinite loop
			# or cheated, there are potentially some more grains to win

			# prepare variables for next player
			lost = gain
			previous = x

			# reverse tables
			t = awale[0]
			awale[0] = awale[1]
			awale[1] = t

			# check if the next player can play
			s = 0
			awale[0].each do | t | s += t end
			if(s == 0) # next player cannot play
				awale[1].each do | t | gain += t end
				current.earn(gain)
				score[i%2] += gain
				break
			else		
				current.earn(gain)
				score[i%2] += gain
			end

			i += 1
		end
		
		return {:score => score, :times => times}
	end

	def checksum(awale,position)
		b = 1
		for i in 0...6
			b += awale[0][i]+awale[1][i]
		end
		b = 12 if b < 12
		position = position % 12
		s = position
		for i in 0...12
			s *= b
			s += awale[i%2][i/2]
		end
		return s
	end

	def play(awale,position)
		done = false
		gain = 0
		# infloop serves to detect infinite loops
		# by storing checksums of configurations
		infloop = Set.new
		while(not done)
			cs = checksum(awale,position)
			if(infloop.include?(cs))
				return -1
			end
			infloop << cs
			
			x = position
			field = (x % 12)/6
			pos = x % 6
	
			hand = awale[field][pos]
			awale[field][pos] = 0
			
			# distributes
			while(hand != 0)
				x += 1
				hand -= 1
				field = (x % 12)/6
				pos = x % 6
				awale[field][pos] += 1
			end

			# check end case
			field = (x % 12)/6
			pos = x % 6
			if field == 0 # my field
				if awale[0][pos] == 1 # potential win
					if awale[1][5-pos] > 0 # win
						gain = 1 + awale[1][5-pos]
						awale[0][pos] = 0
						awale[1][5-pos] = 0
					end
					done = true
				else # more to take
					position = pos
				end
			else # the other player's field
				if awale[1][pos] == 1 # loose
					done = true
				else # more to take
					position = 6+pos
				end
			end
		end

		return gain
	end
end

players = ARGV

if players.size < 2
    print "Usage: ruby Competition.rb Player1 Player2 Player3 ...\n"
    print "Example: ruby Competition.rb DummyPlayer RandomPlayer\n"
    exit
end

competition = Competition.new(players)
competition.start
