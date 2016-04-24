love.viewport = require('libs/viewport').newSingleton()

function draw_board(cells)
    love.graphics.push()

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
            else

                local color = COLOR_RGB[COLORS[cell]]

                love.graphics.setColor(color)
                love.graphics.rectangle("fill", x, y, w, h)
            end
        end
    end

    love.graphics.pop()
end

function draw_cursor(cursor)
    love.graphics.push()

    local w = game.constants.cell_dim
    local h = game.constants.cell_dim
    local gutter = game.constants.cell_gutter

    local x = cursor.x
    local y = cursor.y

    x = x * gutter + ((x - 1) * w)
    y = y * gutter + ((y - 1) * h)

    love.graphics.setColor({ 250, 250, 250 })

    -- A CURSOR

    -- TOP LEFT
    love.graphics.line(x, y, x, y + 2)
    love.graphics.line(x, y, x + 2, y)

    -- TOP RIGHT
    love.graphics.line(x + w, y, x + w, y + 2)
    love.graphics.line(x + w, y, x + w - 2, y)

    -- BOTTOM LEFT
    love.graphics.line(x, y + h, x, y + h - 2)
    love.graphics.line(x, y + h, x + 2, y + h)

    -- BOTTOM RIGHT
    love.graphics.line(x + w, y + h, x + w, y + h - 2)
    love.graphics.line(x + w, y + h, x + w - 2, y + h)

    love.graphics.pop()
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(game.scale, game.scale)

    draw_board(game.board.cells)

    draw_cursor(game.select_cursor)

    if (game.swap_cursor.active == true) then draw_cursor(game.swap_cursor) end

    love.graphics.scale(1)
    love.graphics.pop()
end
