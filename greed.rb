
class DiceSet
	attr_reader :values

	def roll(n)
	   @values = (1..n).map{rand(6)+1}
	   
	end

	def score
		@counts = Array.new(7,0)
		@values.each {|v| @counts[v]+=1}
		score = 0
		(1..6).each do |i|
			if i == 1
				score += (@counts[1]/3)*1000 + (@counts[1]%3)*100
			else
				score += (@counts[i]/3)*i*100
			end
			score += (@counts[5]%3)*50 if i == 5
		end
		score
	end

	def non_scoring_dice
	   num = 0
	   [2,3,4,6].each do |i|
		   num += @counts[i]%3
	   end
	   num
	end
	
	def all_scoring?
		non_scoring_dice == 0
	end
end

class Player
	attr_accessor :name, :in_game, :dice
	attr_reader :total_score
	


	def initialize
		@total_score = 0
		@dice = DiceSet.new
		@in_game = false
	end

	def add_score(score)
		@total_score += score
	end

	def ingame?
		in_game == true
	end
end

class GreedGame
    PLAYER1 = 0
	PLAYER2 = 1
	
	def initialize
		@p1 = Player.new
		@p2 = Player.new
		@turn = PLAYER1
	end

	def get_player_info
		puts "Welcome to GREED Game\n\n"
		print "Enter Player 1's name : "
		@p1 = Player.new
		@p1.name = gets.chomp
		print "Enter Player 2's name : "
		@p2 = Player.new
		@p2.name = gets.chomp
	end

	def get_choice
		ans = nil
		loop do
			print "Want to roll again[y/n] : "
			ans = gets.chomp
			break if ans == "y" or ans == "n" 
		end
		ans
	end

	def play_turn(current_player)
		current_score = 0
		num_scoring_dice = 5
		zero_point_roll = false
		loop do
			current_player.dice.roll(num_scoring_dice)
			score = current_player.dice.score
			current_score += score
			non_scoring_dice = current_player.dice.non_scoring_dice
			puts "You rolled #{current_player.dice.values}"
			puts "Your score for this roll is #{score}"
			num_scoring_dice = non_scoring_dice
			num_scoring_dice = 5 if  current_player.dice.all_scoring?
			zero_point_roll = true if score == 0
			break if zero_point_roll
			if num_scoring_dice > 0
				ans = get_choice
				break if ans == "n"
			end
		end
		current_score = 0 if zero_point_roll
		current_score
	end

	def play
		final_round = false
		loop do
			if @turn == PLAYER1 and (@p1.total_score >= 3000 or @p2.total_score >=3000)
				final_round = true
			end
			current_player = @turn == PLAYER1 ? @p1 : @p2
			puts "======================================="
			puts "===========FINAL ROUND=================" if final_round
			puts "#{current_player.name}'s turn"
			if not current_player.ingame?
				puts "Roll 300 to get in the game"
			end
			current_score = play_turn(current_player)
			if not current_player.ingame? and current_score >= 300
				current_player.in_game = true
			end
			current_player.add_score(current_score) if current_player.ingame?
			puts "You accumulated score is #{current_player.total_score}"
			@turn = [PLAYER1,PLAYER2][(@turn+1)%2]
			break if final_round and @turn == PLAYER1
		end
		
	end

	def get_winner
		puts "\n\n=======RESULTS================"
		puts "#{@p1.name}'s score is #{@p1.total_score}"
		puts "#{@p2.name}'s score is #{@p2.total_score}"
		if @p1.total_score > @p2.total_score
			puts "#{@p1.name} wins"
		elsif @p1.total_score < @p2.total_score
			puts " #{@p2.name} wins"
		else 
			puts "Draw"
		end
	end




end

g = GreedGame.new
g.get_player_info
g.play
g.get_winner

	


	







	

