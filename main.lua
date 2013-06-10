require("loveos.loveos")

function love.load()
  loveos:load()
end

function love.update(dt)
  loveos:update(dt)
end

function love.draw()

  love.graphics.setColor(255,255,255)
  love.graphics.rectangle("fill", 0, 0, 1024, 640)

  loveos:draw()
end

function love.keypressed(key, unicode)
  loveos:keypressed(key, unicode)
end

function love.keyreleased(key)
  loveos:keyreleased(key)
end
