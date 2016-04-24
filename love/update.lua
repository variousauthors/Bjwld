

function love.update(dt)
    local should_swap = false

    --Update here

    if (game.active_cursor.input ~= nil) then

        if (game.select_cursor.active == true) then
            -- move the select cursor freely around the board

            if (game.active_cursor.input == 'up') then game.active_cursor.y = game.active_cursor.y - 1 end
            if (game.active_cursor.input == 'down') then game.active_cursor.y = game.active_cursor.y + 1 end
            if (game.active_cursor.input == 'left') then game.active_cursor.x = game.active_cursor.x - 1 end
            if (game.active_cursor.input == 'right') then game.active_cursor.x = game.active_cursor.x + 1 end

        elseif (game.swap_cursor.active == true) then
            -- set the swap cursor to a cardinal offset from the select cursor

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

    game.active_cursor.input = nil

    if (should_swap) then
        local x1 = game.select_cursor.x
        local y1 = game.select_cursor.y

        local x2 = game.swap_cursor.x
        local y2 = game.swap_cursor.y

        local cells = game.board.cells

        local tmp = cells[y1][x1]
        cells[y1][x1] = cells[y2][x2]
        cells[y2][x2] = tmp

        game.select_cursor.x = game.swap_cursor.x
        game.select_cursor.y = game.swap_cursor.y
    end

    -- TODO check the board for rows or cols

    local cells = game.board.cells
    local dirs = {
        { x = 0, y = 1 },
        { x = 1, y = 0 },
        { x = -1, y = 0 },
        { x = 0, y = -1 },
    }

    for y = 1, #(cells), 1 do
        for x = 1, #(cells[y]), 1 do
            local cell = cells[y][x]

            for i = 1, #(dirs), 1 do
                local dir = dirs[i]
                local dx = dir.x
                local dy = dir.y
                local nx = x + dx
                local ny = y + dy

                local neighbour = board_get_cell(game.board, nx, ny)
                local group = { build_entry(cell, x, y) }

                while (neighbour and neighbour == cell) do
                    table.insert(group, build_entry(neighbour, nx, ny))

                    nx = nx + dx
                    ny = ny + dy
                    neighbour = board_get_cell(game.board, nx, ny)
                end

                if #(group) > 2 then
                    for j = 1, #(group), 1 do
                        local cell = group[j]

                        game.board.cells[cell.y][cell.x] = 'empty'
                    end
                end
            end
        end
    end
end

function build_entry(color, x, y)
    return {
         color = color,
         x = x,
         y = y
    }
end
function board_get_cell(board, x, y)
    local cell = nil

    if (x > 0 and x < board.width + 1) and (y > 0 and y < board.height + 1) then
        cell = board.cells[y][x]
    end

    return cell
end
