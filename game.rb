class Player
	def initialize (side, brd)
		@health = 30
		@total_mana = 0
		@remaining_mana = 0
		@side = side
		@hand = []
		@deck = []
		@board = brd
	end

	#Player takes damage equivalent to the attack value of the attacking card
	def takeDamage (damage)
		@health = @health - damage
	end

	#Turn starts and the player draws a card from the deck, mana is incremented by one (so
	#long as his total mana is < 10) and the usable mana of the player is refreshed to total mana.
	#Finally, we unlock the player's board so that it may attack
	def startTurn
		drawCard()
		if @total_mana < 10
			@total_mana += 1
		end
		@remaining_mana = @total_mana
		@board.resetBoard(self)
	end

	#Temporary function (probably). Seeds the player's deck with 30 cards, and then shuffles the deck.
	#Will most likely end up as a simple shuffle method
	def createDeck
		10.times do |f|
			@deck.push(Card.new(5, 5, 5, '5 cost minion'))
		end
		10.times do |f|
			@deck.push(Card.new(2, 2, 2, '2 cost minion'))
		end
		10.times do |f|
			@deck.push(Card.new(1, 1, 1, '1 cost minion'))
		end		
		@deck.shuffle!	
	end

	#The player pops a card out of the deck and pushes it into his hand
	def drawCard
		@hand = @hand.push(@deck.pop)
	end

	#The player adds a card to his side of the board, fails if he does not have enough mana.
	def playCard (card)
		if card.cost > @remaining_mana
			p "Not enough mana!"
		else
			board.addToBoard(self, card)
		end
	end

	def attackWithCard (playerCard, opponentCard, board)

	end

	#Testing function to see the status of th eplayer
	def testOutput
		puts @health
		puts @total_mana
		puts @remaining_mana
		puts @side
		p @hand
	end

	attr_reader :health, :mana, :side, :deck
end

class Board
	def initialize
		@p1Board = []
		@p2Board = []
	end

	def addToBoard(player, card)
		if player.side == 1
			@p1Board.push(card)
		else
			@p2Board.push(card)
		end
	end

	def resetBoard (player)
		if(player.side == 1)
			@p1Board.each do |c|
				c.played = false
			end
		elsif(player.side == 2)
			@p2Board.each do |c|
				c.played = false
			end
		end
	end

	def printBoard
		p @p1Board
		p @p2Board
	end

	attr_accessor :p1Board, :p2Board
end


class Card
	@health = 0
	@attack = 0
	@cost = 0
	@played
	@name

	def initialize (h, a, c, name)
		@health = h
		@attack = a
		@cost = c
		@name = name
		@played = false
	end

	def attack (target)
		if (@played == true)
			puts "This minion already attacked!"
		else
			target.takeDamage(attack)
			self.takeDamage(target.attack)
			@played = true
		end
	end

	def takeDamage (dmg)
		health -= dmg
	end

	def printCard
		puts "+--------- +"
		if @health/10 == 0
			puts "| hp: #{@health}    |"
		else 
			puts "| hp: #{@health}   |"
		end
		puts "|          |"
		if @attack/10 == 0
			puts "| atk: #{@health}   |"
		else 
			puts "| atk: #{@health}  |"
		end
		puts "|          |"
		puts "|          |"
		puts "+--------- +"
	end

	attr_reader :health, :attack, :cost
	attr_accessor :played
end

board = Board.new
player = Player.new(1, board)


player.createDeck

player.deck.each do |c|
	c.printCard
end

player.startTurn
player.playCard(player.deck.pop)
board.printBoard	


