

function love.update(dt)
    local should_swap = false

    --Update here

    if (game.active_cursor.input ~= nil) then

        if (game.select_cursor.active == true) then

            if (game.active_cursor.input == 'up') then game.active_cursor.y = game.active_cursor.y - 1 end
            if (game.active_cursor.input == 'down') then game.active_cursor.y = game.active_cursor.y + 1 end
            if (game.active_cursor.input == 'left') then game.active_cursor.x = game.active_cursor.x - 1 end
            if (game.active_cursor.input == 'right') then game.active_cursor.x = game.active_cursor.x + 1 end
        elseif (game.swap_cursor.active == true) then

            if (game.active_cursor.input == 'up') then
                game.active_cursor.y = game.select_cursor.y - 1
                game.active_cursor.x = game.select_cursor.x
            end
            if (game.active_cursor.input == 'down') then
                game.active_cursor.y = game.select_cursor.y + 1
                game.active_cursor.x = game.select_cursor.x
            end
            if (game.active_cursor.input == 'left') then
                game.active_cursor.y = game.select_cursor.y
                game.active_cursor.x = game.select_cursor.x - 1
            end
            if (game.active_cursor.input == 'right') then
                game.active_cursor.y = game.select_cursor.y
                game.active_cursor.x = game.select_cursor.x + 1
            end
        end

        -- TODO clamp active_cursor position to the board dimensions
        if (game.swap_cursor.active == true) then
            -- clamp the swap cursor to the select cursor's neighbourhood

            if (game.swap_cursor.x < game.select_cursor.x - 1) then game.swap_cursor.x = game.select_cursor.x - 1 end
            if (game.swap_cursor.x > game.select_cursor.x + 1) then game.swap_cursor.x = game.select_cursor.x + 1 end
            if (game.swap_cursor.y < game.select_cursor.y - 1) then game.swap_cursor.y = game.select_cursor.y - 1 end
            if (game.swap_cursor.y > game.select_cursor.y + 1) then game.swap_cursor.y = game.select_cursor.y + 1 end
        end

        if (game.active_cursor.input == 'select') then
            if (game.select_cursor.active == true) then
                -- change to the swap cursor

                game.select_cursor.active = false
                game.swap_cursor.x = game.select_cursor.x
                game.swap_cursor.y = game.select_cursor.y

                game.swap_cursor.active = true
                game.active_cursor = game.swap_cursor
            elseif game.swap_cursor.active == true then
                -- remove the swap cursor, perform the swap, etc

                game.swap_cursor.active = false

                game.select_cursor.active = true
                game.active_cursor = game.select_cursor

                if (game.swap_cursor.x ~= game.select_cursor.x or game.swap_cursor.y ~= game.select_cursor.y) then
                    should_swap = true
                end
            end
        end
    end

    if (should_swap) then
        local x1 = game.select_cursor.x
        local y1 = game.select_cursor.y

        local x2 = game.swap_cursor.x
        local y2 = game.swap_cursor.y

        local cells = game.board.cells

        local tmp = cells[y1][x1]
        cells[y1][x1] = cells[y2][x2]
        cells[y2][x2] = tmp
    end

    game.active_cursor.input = nil
end
