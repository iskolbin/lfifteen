-- Fifteen puzle game adapted from C89 short version
-- at http://rosettacode.org/wiki/15_Puzzle_Game#C89.2C_22_lines_version

local Game = {
	UP = 'UP',
	DOWN = 'DOWN',
	LEFT = 'LEFT',
	RIGHT = 'RIGHT',
	MOVES = {'UP', 'DOWN', 'LEFT', 'RIGHT'},
}

Game = {__index = Game}

function Game.new( nRows, nCollumns, nShuffles )
	local self = setmetatable( {
		nRows = nRows or 4,
		nCollumns = nCollumns or 4,
		cells = {}
	}, Game )
	self.holeRow = self.nRows
	self.holeCollumn = self.nCollumns
	local k = 1
	for i = 1, self.nRows do
		self.cells[i] = {}
		for j = 1, self.nCollumns do
			self.cells[i][j] = k
			k = k + 1
		end
	end
	self.cells[self.nRows][self.nCollumns] = 0
	nShuffles = nShuffles or 1
	while nShuffles > 0 do
		if self:update( Game.MOVES[math.random(#Game.MOVES)] ) then
			nShuffles = nShuffles - 1
		end
	end
	return self
end

function Game:update( move )
  local i, j = self.holeRow, self.holeCollumn
	if move == Game.UP then
		i = i - 1
	elseif move == Game.DOWN then
		i = i + 1
	end
	if move == Game.LEFT then
		j = j - 1
	elseif move == Game.RIGHT then
		j = j + 1
	end
	if i >= 1 and i <= self.nRows and j >= 1 and j <= self.nCollumns then
		self.cells[self.holeRow][self.holeCollumn] = self.cells[i][j]
		self.cells[i][j] = 0
		self.holeRow = i
		self.holeCollumn = j
		return true
	end
	return false
end

function Game:isfinished()
	local k = 1
	for i = 1, self.nRows do
		for j = 1, self.nCollumns do
			if self.cells[i][j] ~= k then
				return false
			end
			if k == self.nRows * self.nCollumns - 1 then
				return true
			end
			k = k + 1
		end
	end
	return true
end

function Game:show()
	for i = 1, self.nRows do
		for j = 1, self.nCollumns do
			if j > 1 then io.write( ' ' ) end
			if self.cells[i][j] == 0 then
				io.write( ' *' )
			else
				io.write( ('%2d'):format( self.cells[i][j] ))
			end
		end
		io.write('\n')
	end
end

function Game.move()
	local ch = io.read():sub(1,1)
	if     ch == 'w' or ch == 'W' or ch == 'k' or ch == 'K' then return Game.UP
	elseif ch == 's' or ch == 'S' or ch == 'j' or ch == 'J' then return Game.DOWN
	elseif ch == 'a' or ch == 'A' or ch == 'h' or ch == 'H' then return Game.LEFT
	elseif ch == 'd' or ch == 'D' or ch == 'l' or ch == 'L' then return Game.RIGHT
	end
end

function Game:run( seed )
	math.randomseed( seed or os.time() )
	self:show()
	while not self:isfinished() do
		self:update( self:move())
		self:show()
	end
	print( "You win!" )
end

if ... == nil then
	Game.new():run()
end

return setmetatable( Game, {__call = function(_,...) return Game.new(...) end} )
