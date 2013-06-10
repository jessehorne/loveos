--
-- Virtual terminal
-- LoveOS by default outputs to this terminal
--
-- This terminal can only handle monospace fonts.
-- You are welcome to improve it
--

local term = {
  -- The buffer contains the text data the terminal holds
  buffer = {},
  -- Width of the terminal in characters
  w = nil,
  -- Height of the terminal in characters
  h = nil,
  -- Line offset. Used for scrolling
  lineOff = 0,
  -- The canvas the terminal draws to
  canvas = nil,
  -- The font the terminal is using
  font = nil,
  -- Width of the font the terminal is using. Used for calculating some stuff
  fontW = nil,
  -- Height of the font the terminal is using. Used for calculating some stuff
  fontH = nil,
  -- Color to draw the terminal text with
  color = {255, 255, 255},
  -- Position of the text cursor
  cursor = 0
}

-- Initialize the terminal
-- width  <- Width of the terminal in characters
-- height <- Height of the terminal in characters
-- font   <- Font for the terminal to use
function term:init(width, height, font)
  self.w = width
  self.h = height
  self.font = font
  self.fontW = self.font:getWidth('a')
  self.fontH = self.font:getHeight()
  self.canvas = love.graphics.newCanvas(self.w * self.fontW, self.h * self.fontH)
end

-- Draw the terminal
-- x <- X position to draw the terminal at
-- y <- Y position to draw the terminal at
function term:draw(x, y)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.canvas, x, y)
end

-- Updates the canvas of the terminal
-- It renders everything. This is a very expensive operation.
-- Only use when the terminal needs to be updated.
function term:update()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
  love.graphics.setColor(unpack(self.color))
  local y = 0
  for i = self.lineOff, (self.h + self.lineOff) - 1 do
    love.graphics.print(string.sub(table.concat(self.buffer), i * self.w + 1, (i * self.w) + self.w), 0, y * self.fontH)
    y = y + 1
  end
  -- Draw the cursor
  love.graphics.rectangle('fill', (self.cursor % self.w) * self.fontW, (math.floor((self.cursor / self.w)) - self.lineOff) * self.fontH, self.fontW, self.fontH)
  love.graphics.setCanvas()
end

function term:feed(str)
  for i = 1, #str do
    local c = str:sub(i, i)
    -- Ignore null characters, as they break things
    if c == '\0' then return
    -- If encountering a new line character, fill the remaining line with spaces
    elseif c == '\n' or c == '\r' then
      local size = #(table.concat(self.buffer))
      local spaces = self.w - (size % self.w)
      table.insert(self.buffer, string.rep(' ', spaces))
      self.cursor = self.cursor + spaces
      -- Adjust line offset if needed
      self.lineOff = math.floor((size / self.w) - (self.h - 2))
      if self.lineOff < 0 then self.lineOff = 0 end
    elseif c == '\b' then self:pop()
    else
      table.insert(self.buffer, c)
      self.cursor = self.cursor + 1
    end
  end
end

function term:scroll(amount)
  self.lineOff = self.lineOff + amount
  if self.lineOff < 0 then self.lineOff = 0 end
  self:update()
end

-- Remove last character
function term:pop()
  table.remove(self.buffer, #self.buffer)
  self.cursor = self.cursor - 1
end

function term:clear()
  self.buffer = {}
  self.cursor = 0
end

return term