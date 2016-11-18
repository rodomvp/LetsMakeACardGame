class Player
	def initialize (side, brd)
		@health = 30
		@total_mana = 10
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
			@board.addToBoard(self, card)
		end
	end

	def attackCardWithCard (playerCard, opponentCard, opponent)
		if playerCard.played?
			p "This card already attacked!"
		else
			opponentCard.takeDamage(playerCard.attack)
			playerCard.takeDamage(opponentCard.attack)
			if opponentCard.currentHealth <= 0
				opponentCard.die(@board, opponent)
			end
			if playerCard.currentHealth <= 0
				playerCard.die(@board, self)
			end
			playerCard.played = true
		end
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
		@p1GY = []
		@p2GY = []
	end

	#Adds a card to the board for the specified player
	def addToBoard(player, card)
		if player.side == 1
			@p1Board.push(card)
		else
			@p2Board.push(card)
		end
	end

	#Refreshes the ability to attack for any card on the player's board. Should happen at
	#the start of every turn
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

	#Displays the entire board status: including the 2 active boards of both players as well
	#as their respective graveyards
	def printBoard
		puts "Player 1's Board"
		@p1Board.each do |c|
			c.printCard
		end
		puts "Player 2's Board";
		@p2Board.each do |c|
			c.printCard
		end
		puts "Player 1's GY"
		@p1GY.each do |c|
			c.printCard
		end
		puts "Player 2's GY";
		@p2GY.each do |c|
			c.printCard
		end
	end

	attr_accessor :p1Board, :p2Board, :p1GY, :p2GY
end


class Card
	@health = 0
	@currentHealth = 0
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
		@currentHealth = @health
	end

	#Simple boolean to see if a card has already taken it's turn
	def played?
		return @played
	end

	#Removes the card from the player's active board and moves it into the graveyard
	def die (board, player)
		@currentHealth = health
		if player.side == 1
			board.p1Board.delete(self)
			board.p1GY.push(self)
		elsif player.side == 2
			board.p2Board - [self]
			board.p2GY.push(self)
		end
	end

	#The card loses current health equal to the damage of the attacker
	def takeDamage (dmg)
		@currentHealth -= dmg
	end

	#Prints out the card in a simple, easy to read format
	def printCard
		puts "+--------- +"
		if @health/10 == 0
			puts "| hp: #{@currentHealth}    |"
		else 
			puts "| hp: #{@currentHealth}   |"
		end
		puts "|          |"
		if @attack/10 == 0
			puts "| atk: #{@attack}   |"
		else 
			puts "| atk: #{@attack}  |"
		end
		puts "|          |"
		puts "|          |"
		puts "+--------- +"
	end

	attr_reader :health, :attack, :cost
	attr_accessor :played, :currentHealth
end

board = Board.new
player1 = Player.new(1, board)
player2 = Player.new(2, board)


player1.createDeck
player2.createDeck

player1.deck.each do |c|
	c.printCard
end

player1.startTurn
player1.playCard(player1.deck.pop)
player1.playCard(player1.deck.pop)
player1.playCard(player1.deck.pop)
player2.startTurn
player2.playCard(player2.deck.pop)
player2.playCard(player2.deck.pop)
player2.playCard(player2.deck.pop)
board.printBoard
player1.attackCardWithCard(board.p1Board.first, board.p2Board.first, player2)
board.printBoard	


