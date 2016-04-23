love.viewport = require('libs/viewport').newSingleton()

function love.draw()
    love.graphics.push()
    love.graphics.scale(game.scale, game.scale)

    local cells = game.board.cells
    local w = game.constants.cell_dim
    local h = game.constants.cell_dim
    local gutter = game.constants.cell_gutter

    for y = 1, #(cells), 1 do

        for x = 1, #(cells[y]), 1 do
            local cell = cells[y][x]
            local x = (x * gutter) + ((x - 1) * w)
            local y = (y * gutter) + ((y - 1) * h)

            if cell == EMPTY then

                love.graphics.setColor({ 50, 50, 50 })
                love.graphics.rectangle("fill", x + w/2 - 0.5, y + h/2 - 0.5, 1, 1)
                love.graphics.setColor({ 255, 255, 255 })
            else

                love.graphics.rectangle("fill", x, y, w, h)
            end
        end
    end

    love.graphics.scale(1)
    love.graphics.pop()
end
