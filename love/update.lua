

function love.update(dt)

    --Update here

    if (game.cursor.input ~= nil) then
        if (game.cursor.input == 'up') then game.cursor.y = game.cursor.y - 1 end
        if (game.cursor.input == 'down') then game.cursor.y = game.cursor.y + 1 end
        if (game.cursor.input == 'left') then game.cursor.x = game.cursor.x - 1 end
        if (game.cursor.input == 'right') then game.cursor.x = game.cursor.x + 1 end

        -- TODO clamp cursor position to the board dimensions
    end


    game.cursor.input = nil
end
