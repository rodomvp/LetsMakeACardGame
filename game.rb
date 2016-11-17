class Player
	def initialize
		@health = 30
		@total_mana = 0
		@remaining_mana = 0
		@cards = []
	end

	def takeDamage (damage)
		@health = @health - damage
	end

	def startTurn 
		drawCard()
		if @total_mana < 10
			@total_mana += 1
		end
	end

	def randomCard
		card = Card.new(5, 5, 5)
	end

	def drawCard
		@cards = @cards.push(randomCard)
	end

	def playCard (card)
		if card.cost > @remaining_mana
			p "Not enough mana!"
		else



	def testOutput
		puts @health
		puts @total_mana
		puts @remaining_mana
		p @cards
	end

	attr_reader :health, :mana
end

class Board
	def initialize
		

class Card
	@health = 0;
	@attack = 0;
	@cost = 0;

	def initialize (h, a, c)
		@health = h;
		@attack = a;
		@cost = c;
	end

	def attack (target)
		target.takeDamage(attack)
		self.takeDamage(target.attack)
	end

	def takeDamage (dmg)
		health -= dmg
	end

	attr_reader :health, :attack, :cost
end


p = Player.new

p.testOutput
p.startTurn
p.testOutput